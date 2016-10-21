#= require Alg
#= require Config
#= require Dom
#= require EventHandlers
#= require Move
#= require Pieces3D
#= require OneChange

class CubeAnimation
  @last_id = 0
  @by_id = {}
  @webgl_cubes = 0

  @initialize: ->
    CubeAnimation.webgl_browser = (->
      try
        return !!window.WebGLRenderingContext and !!document.createElement("canvas").getContext("experimental-webgl")
      catch e
        return false
    )()

    CubeAnimation.canvas_browser = !!window.CanvasRenderingContext2D
    if CubeAnimation.canvas_browser
      log_error("No WebGL support in this browser. Falling back on regular Canvas.") unless CubeAnimation.webgl_browser
    else
      log_error("No Canvas support in this browser. Giving up.")

  @create_in_dom: (parent_selector, config, div_attributes) ->
    new_pig = $("<div #{div_attributes} data-config=\"#{config}\"></div>").appendTo($(parent_selector))
    new CubeAnimation(new_pig)

  next_cube: ->
    ids = Object.keys(CubeAnimation.by_id)
    next_id = ids[(ids.indexOf(@id.toString()) + 1) % ids.length]
    CubeAnimation.by_id[next_id]

  previous_cube: ->
    ids = Object.keys(CubeAnimation.by_id)
    previous_id = ids[(ids.indexOf(@id.toString()) + ids.length - 1) % ids.length]
    CubeAnimation.by_id[previous_id]

  constructor: (roofpig_div) ->
    unless CubeAnimation.canvas_browser
      roofpig_div.html("Your browser does not support <a href='http://khronos.org/webgl/wiki/Getting_a_WebGL_Implementation'>WebGL</a>.<p/> Find out how to get it <a href='http://get.webgl.org/'>here</a>.")
      roofpig_div.css(background: '#f66')
      return

    try
      @id = CubeAnimation.last_id += 1
      CubeAnimation.by_id[@id] = this

      @config = new Config(roofpig_div.data('config'))

      use_canvas = @config.flag('canvas') || not CubeAnimation.webgl_browser || CubeAnimation.webgl_cubes >= 16
      if use_canvas
        @renderer = new THREE.CanvasRenderer(alpha: true) # alpha -> transparent
      else
        CubeAnimation.webgl_cubes += 1
        @renderer = new THREE.WebGLRenderer(antialias: true, alpha: true)

      @dom = new Dom(@id, roofpig_div, @renderer, @config.alg != "", @config.flag('showalg'))
      @scene = new THREE.Scene()
      @world3d =
        camera: new Camera(@config.hover, @config.pov),
        pieces: new Pieces3D(@scene, @config.hover, @config.colors, use_canvas)

      @alg = new Alg(@config.alg, @world3d, @config.algdisplay, @config.speed, @dom)

      if (@config.setup) then new Alg(@config.setup, @world3d).to_end()
      @alg.mix() unless @config.flag('startsolved')

      if this.cube_count() == 1
        EventHandlers.set_focus(this)

      @changers = {}
      this.animate(true)

      EventHandlers.initialize()
    catch e
      roofpig_div.html(e.message)
      roofpig_div.css(background: '#f66')

  remove: ->
    if this == EventHandlers.focus()
      new_focus = (if this.cube_count() == 1 then null else this.next_cube())
      EventHandlers.set_focus(new_focus)
    delete CubeAnimation.by_id[@id]
    @dom.div.remove()

  cube_count: ->
    Object.keys(CubeAnimation.by_id).length

  animate: (first_time = false) ->  # called for each redraw
    now = (new Date()).getTime()

    for own category, changer of @changers
      if changer
        changer.update(now)
        if changer.finished() then @changers[category] = null
        any_change = true

    if any_change || first_time
      @renderer.render @scene, @world3d.camera.cam

    requestAnimationFrame => this.animate() # request next frame

  add_changer: (category, changer) ->
    if @changers[category] then @changers[category].finish()
    @changers[category] = changer

  button_click: (name, shift) ->
    switch name
      when 'play'
        changer = unless shift then @alg.play(@world3d) else new OneChange( => @alg.to_end(@world3d))
      when 'pause'
        @alg.stop()
      when 'next'
        changer = @alg.next_move().show_do(@world3d) unless @alg.at_end()
      when 'prev'
        changer = @alg.prev_move().show_undo(@world3d) unless @alg.at_start()
      when 'reset'
        changer = new OneChange( => @alg.to_start(@world3d))

    if changer
      this.add_changer('pieces', changer)
