#= require roofpig/Alg
#= require roofpig/Config
#= require roofpig/DomHandler
#= require roofpig/EventHandlers
#= require roofpig/Move
#= require roofpig/OneChange
#= require roofpig/Pieces3D

class @Display
  @unique_id = 0
  @instances = []

  next_display: ->
    next_id = (@id % Display.unique_id) + 1
    Display.instances[next_id]

  previous_display: ->
    prev_id = ((@id + Display.unique_id - 2) % Display.unique_id) + 1
    Display.instances[prev_id]

  constructor: (roofpig_div, webgl_works, canvas_works) ->
    unless canvas_works
      roofpig_div.html("Your browser does not support <a href='http://khronos.org/webgl/wiki/Getting_a_WebGL_Implementation'>WebGL</a>.<p/> Find out how to get it <a href='http://get.webgl.org/'>here</a>.")
      roofpig_div.css(background: '#f66')
      return

    @id = Display.unique_id += 1
    Display.instances[@id] = this

    @config = new Config(roofpig_div.data('config'))

    if @config.flag('canvas') || not webgl_works
      @renderer = new THREE.CanvasRenderer(alpha: true) # alpha -> transparent
    else
      @renderer = new THREE.WebGLRenderer(antialias: true, alpha: true)

    @dom_handler = new DomHandler(@id, roofpig_div, @renderer)

    @scene = new THREE.Scene()
    @camera = new Camera(@config.hover, @config.pov)
    @world3d = { pieces: new Pieces3D(@scene, @config), camera: @camera }

    if (@config.setup)
      setup_alg = new Alg(@config.setup)
      until setup_alg.at_end()
        setup_alg.next_move().do(@world3d)

    unless @config.alg == ""
      @dom_handler.add_alg_area(@config.flag('showalg'))
      @alg = new Alg(@config.alg, @dom_handler).premix(@world3d)

    if @id == 1
      EventHandlers.set_active_display(this)

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
      @renderer.render @scene, @camera.cam

    requestAnimationFrame => this.animate() # request next frame

  add_changer: (category, changer) ->
    if @changers[category] then @changers[category].finish()
    @changers[category] = changer

  button_click: (name, shift) ->
    switch name
      when 'play'
        unless shift
          this.add_changer('move', @alg.play(@world3d))
        else
          this.add_changer('move', new OneChange( => @alg.to_end(@world3d)))
      when 'pause'
        @alg.stop()
      when 'next'
        unless @alg.at_end()
          this.add_changer('move', @alg.next_move().show_do(@world3d))
      when 'prev'
        unless @alg.at_start()
          this.add_changer('move', @alg.prev_move().show_undo(@world3d))
      when 'reset'
        this.add_changer('move', new OneChange( => @alg.to_start(@world3d)))
