#= require three.min
#= require roofpig/Alg
#= require roofpig/DomHandler
#= require roofpig/InputHandler
#= require roofpig/Move
#= require roofpig/Pieces3D
#= require roofpig/Settings

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Display
  @unique_id = 0

  constructor: (roofpig_div) ->
    @id = Display.unique_id += 1

    @input_handler = new InputHandler(this)
    @settings = new Settings(roofpig_div)

    @renderer = new THREE.WebGLRenderer({ antialias: true })
    @dom_handler = new DomHandler(@id, roofpig_div, @renderer)

    @camera = new THREE.PerspectiveCamera(24, 1, 1, 100)
    @camera.position.set(25, 25, 25)
    @camera.up.set(0,0,1);
    @camera.lookAt(v3(0, 0, 0))

    @scene = new THREE.Scene()
    @pieces3d = new Pieces3D(@scene, @settings)

    @alg = new Alg(@settings.alg, @dom_handler).premix(@pieces3d)
    @animations = []

    this.animate()

  # this function is executed on each animation frame
  animate: ->
    for animation in @animations
      animation.animate()

    @renderer.render @scene, @camera

    # request new frame
    requestAnimationFrame => this.animate()

  new_single_move: (move) ->
    if @single_move then @single_move.finish()
    @single_move = move

    @animations.push(move)

  next: ->
    unless @alg.at_end()
      this.new_single_move(@alg.next_move().do(@pieces3d))

  prev: ->
    unless @alg.at_start()
      this.new_single_move(@alg.prev_move().undo(@pieces3d))

  reset: ->
    until @alg.at_start()
      @alg.prev_move().undo(@pieces3d).finish()

  button_click: (name) ->
    switch name
      when 'play'
        @animations.push(@alg.play(@pieces3d))
      when 'pause'
        @alg.stop()
      when 'next'
        this.next()
      when 'prev'
        this.prev()
      when 'reset'
        this.reset()
