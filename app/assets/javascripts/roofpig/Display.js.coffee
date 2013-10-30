#= require three.min
#= require roofpig/Move
#= require roofpig/Pieces3D

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Display
  constructor: ->
    canvas_div = $("#canvas_1")

    @input_handler = new InputHandler(this)
    @settings = new Settings(canvas_div)

    @renderer = new THREE.WebGLRenderer({ antialias: true })
    canvas_size = Math.min(canvas_div.width(), canvas_div.height())
    @renderer.setSize(canvas_size, canvas_size)
    $("#buttons_1").before(@renderer.domElement);
    @buttons = new ButtonRow()
    $('#buttons_1c').append(@buttons.all)

    @camera = new THREE.PerspectiveCamera(24, 1, 1, 100)
    @camera.position.set(25, 25, 25)
    @camera.up.set(0,0,1);
    @camera.lookAt(v3(0, 0, 0))

    @scene = new THREE.Scene()
    Pieces3D.make_stickers(@scene, @settings)

    @alg = new Alg(@settings.alg, @buttons)
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
      this.new_single_move(@alg.next_move())

  prev: ->
    unless @alg.at_start()
      this.new_single_move(@alg.prev_move())

  reset: ->
    until @alg.at_start()
      @alg.prev_move().finish()

  button_click: (name) ->
    switch name
      when 'play' then @animations.push(@alg.play(this))
      when 'pause' then @alg.stop()
      when 'next' then this.next()
      when 'prev' then this.prev()
      when 'reset' then this.reset()
