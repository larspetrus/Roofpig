#= require roofpig/Alg
#= require roofpig/DomHandler
#= require roofpig/InputHandler
#= require roofpig/Move
#= require roofpig/Pieces3D
#= require roofpig/Settings

class @Display
  @unique_id = 0
  @instances = {}

  constructor: (roofpig_div) ->
    @id = Display.unique_id += 1
    Display.instances[@id] = this

    @settings = Settings.from_page(roofpig_div)

    if @settings.flag('canvas')
      @renderer = new THREE.CanvasRenderer()
    else
      @renderer = new THREE.WebGLRenderer({ antialias: true })

    @dom_handler = new DomHandler(@id, roofpig_div, @renderer)
    @camera = new Camera(@settings.hover)
    @scene = new THREE.Scene()
    @pieces3d = new Pieces3D(@scene, @settings)
    unless @settings.alg == ""
      @dom_handler.add_alg_buttons()
      @alg = new Alg(@settings.alg, @dom_handler).premix(@pieces3d)

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
        if changer.finished then @changers[category] = null
        any_change = true

    if any_change
      @renderer.render @scene, @camera.cam

    requestAnimationFrame => this.animate() # request next frame

  add_changer: (category, changer) ->
    if @changers[category] then @changers[category].finish()
    @changers[category] = changer

  next: ->
    unless @alg.at_end()
      this.add_changer('move', @alg.next_move().show_do(@pieces3d))

  prev: ->
    unless @alg.at_start()
      this.add_changer('move', @alg.prev_move().show_undo(@pieces3d))

  to_start: ->
    until @alg.at_start()
      @alg.prev_move().undo(@pieces3d)
    this.force_render()

  to_end: ->
    until @alg.at_end()
      @alg.next_move().do(@pieces3d)
    this.force_render()

  button_click: (name, shift) ->
    switch name
      when 'play'
        unless shift
          this.add_changer('move', @alg.play(@pieces3d))
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
    this.add_changer('force_render', { finished: true, finish: null_func, update: null_func })