#= require three.min
#= require roofpig/Alg
#= require roofpig/DomHandler
#= require roofpig/InputHandler
#= require roofpig/Move
#= require roofpig/Pieces3D
#= require roofpig/Settings

class @Display
  @unique_id = 0

  constructor: (roofpig_div) ->
    @id = Display.unique_id += 1

    @input_handler = new InputHandler(this)
    @settings = new Settings(roofpig_div)
    @renderer = new THREE.WebGLRenderer({ antialias: true })
    @dom_handler = new DomHandler(@id, roofpig_div, @renderer)
    @camera = new Camera()
    @scene = new THREE.Scene()
    @pieces3d = new Pieces3D(@scene, @settings)
    @alg = new Alg(@settings.alg, @dom_handler).premix(@pieces3d)

    this.animate()

  # this function is executed on each animation frame
  animate: ->
    for animation in this.animations()
      if animation
        animation.animate()

    @renderer.render @scene, @camera.cam

    # request new frame
    requestAnimationFrame => this.animate()

  
  animations: ->
    [@move, @spin]
    
  new_move: (move) ->
    if @move then @move.finish()
    @move = move

  new_spin: (spin) ->
    if @spin then @spin.finish()
    @spin = spin

  next: ->
    unless @alg.at_end()
      this.new_move(@alg.next_move().do(@pieces3d))

  prev: ->
    unless @alg.at_start()
      this.new_move(@alg.prev_move().undo(@pieces3d))

  reset: ->
    until @alg.at_start()
      @alg.prev_move().undo(@pieces3d).finish()

  button_click: (name) ->
    switch name
      when 'play'
        this.new_move(@alg.play(@pieces3d))
      when 'pause'
        @alg.stop()
      when 'next'
        this.next()
      when 'prev'
        this.prev()
      when 'reset'
        this.reset()
