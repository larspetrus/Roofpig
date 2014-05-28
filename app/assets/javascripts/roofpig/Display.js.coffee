#= require roofpig/Alg
#= require roofpig/DomHandler
#= require roofpig/InputHandler
#= require roofpig/Move
#= require roofpig/Pieces3D
#= require roofpig/Config

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

    @config = Config.from_page(roofpig_div)

    if @config.flag('canvas') || not webgl_works
      @renderer = new THREE.CanvasRenderer()
    else
      @renderer = new THREE.WebGLRenderer(antialias: true)

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

    @changers = {}
    this.force_render()

    if @id == 1
      InputHandler.set_active_display(this)

    this.animate()


  # this function is executed on each animation frame
  animate: ->
    now = (new Date()).getTime()

    for own category, changer of @changers
      if changer
        changer.update(now)
        if changer.finished() then @changers[category] = null
        any_change = true

    if any_change
      @renderer.render @scene, @camera.cam

    requestAnimationFrame => this.animate() # request next frame

  add_changer: (category, changer) ->
    if @changers[category] then @changers[category].finish()
    @changers[category] = changer

  next: ->
    unless @alg.at_end()
      this.add_changer('move', @alg.next_move().show_do(@world3d))

  prev: ->
    unless @alg.at_start()
      this.add_changer('move', @alg.prev_move().show_undo(@world3d))

  to_start: ->
    until @alg.at_start()
      @alg.prev_move().undo(@world3d)
    this.force_render()

  to_end: ->
    until @alg.at_end()
      @alg.next_move().do(@world3d)
    this.force_render()

  button_click: (name, shift) ->
    switch name
      when 'play'
        unless shift
          this.add_changer('move', @alg.play(@world3d))
        else
          this.to_end()
      when 'pause'
        @alg.stop()
      when 'next'
        this.next()
      when 'prev'
        this.prev()
      when 'reset'
        this.to_start()

  force_render: ->
    null_func = ->
    true_func = -> true
    this.add_changer('force_render', { finished: true_func, finish: null_func, update: null_func })