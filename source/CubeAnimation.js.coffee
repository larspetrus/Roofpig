#= require roofpig/Alg
#= require roofpig/Config
#= require roofpig/Dom
#= require roofpig/EventHandlers
#= require roofpig/Move
#= require roofpig/Pieces3D
#= require roofpig/changers/OneChange

class @CubeAnimation
  @last_id = 0
  @by_id = []
  @webgl_cubes = 0

  next_cube: ->
    next_id = (@id % CubeAnimation.last_id) + 1
    CubeAnimation.by_id[next_id]

  previous_cube: ->
    prev_id = ((@id + CubeAnimation.last_id - 2) % CubeAnimation.last_id) + 1
    CubeAnimation.by_id[prev_id]

  constructor: (roofpig_div, webgl_works, canvas_works) ->
    unless canvas_works
      roofpig_div.html("Your browser does not support <a href='http://khronos.org/webgl/wiki/Getting_a_WebGL_Implementation'>WebGL</a>.<p/> Find out how to get it <a href='http://get.webgl.org/'>here</a>.")
      roofpig_div.css(background: '#f66')
      return

    @id = CubeAnimation.last_id += 1
    CubeAnimation.by_id[@id] = this

    @config = new Config(roofpig_div.data('config'))

    use_canvas = @config.flag('canvas') || not webgl_works || CubeAnimation.webgl_cubes >= 16
    if use_canvas
      @renderer = new THREE.CanvasRenderer(alpha: true) # alpha -> transparent
    else
      CubeAnimation.webgl_cubes += 1
      @renderer = new THREE.WebGLRenderer(antialias: true, alpha: true)

    @dom = new Dom(@id, roofpig_div, @renderer, @config.alg != "", @config.flag('showalg'))
    @scene = new THREE.Scene()
    @world3d = { camera: new Camera(@config.hover, @config.pov), pieces: new Pieces3D(@scene, @config.hover,
      @config.colors, use_canvas) }
    @alg = new Alg(@config.alg, @world3d, @config.algdisplay, @config.speed, @dom)

    if (@config.setup) then new Alg(@config.setup, @world3d).to_end()
    @alg.mix()

    if @id == 1
      EventHandlers.set_focus(this)

    @changers = {}
    this.animate(true)


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
