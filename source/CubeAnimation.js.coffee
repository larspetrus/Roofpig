#= require roofpig/Alg
#= require roofpig/Config
#= require roofpig/Dom
#= require roofpig/EventHandlers
#= require roofpig/Move
#= require roofpig/Pieces3D
#= require roofpig/WorldChangers

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

    if @config.flag('canvas') || not webgl_works || CubeAnimation.webgl_cubes >= 16
      @renderer = new THREE.CanvasRenderer(alpha: true) # alpha -> transparent
    else
      CubeAnimation.webgl_cubes += 1
      @renderer = new THREE.WebGLRenderer(antialias: true, alpha: true)

    @dom = new Dom(@id, roofpig_div, @renderer)

    @scene = new THREE.Scene()
    @camera = new Camera(@config.hover, @config.pov)
    @world3d = { pieces: new Pieces3D(@scene, @config), camera: @camera }

    if (@config.setup)
      setup_alg = new Alg(@config.setup)
      until setup_alg.at_end()
        setup_alg.next_move().do(@world3d)

    unless @config.alg == ""
      @dom.add_alg_area(@config.flag('showalg'))
      @alg = new Alg(@config.alg, @dom).premix(@world3d)

    if @id == 1
      EventHandlers.set_focus(this)

    @world_changers = {}
    this.animate(true)


  animate: (first_time = false) ->  # called for each redraw
    now = (new Date()).getTime()

    for own category, changer of @world_changers
      if changer
        changer.update(now)
        if changer.finished() then @world_changers[category] = null
        any_change = true

    if any_change || first_time
      @renderer.render @scene, @camera.cam

    requestAnimationFrame => this.animate() # request next frame

  add_changer: (category, changer) ->
    if @world_changers[category] then @world_changers[category].finish()
    @world_changers[category] = changer

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
