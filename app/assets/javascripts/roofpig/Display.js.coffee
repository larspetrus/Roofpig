#= require three.min
#= require roofpig/Move
#= require roofpig/Pieces3D
#= require roofpig/Positions

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Display
  constructor: ->
    @input_handler = new InputHandler()

    canvas_div = $("#canvas_1")
    @renderer = new THREE.WebGLRenderer({ antialias: true })
    canvas_size = Math.min(canvas_div.width(), canvas_div.height())
    @renderer.setSize(canvas_size, canvas_size)
    $("#buttons_1").before(@renderer.domElement);

    @camera = new THREE.PerspectiveCamera(24, 1, 1, 100)
    @camera.position.set(25, 25, 25)
    @camera.up.set(0,0,1);
    @camera.lookAt(v3(0, 0, 0))

    @scene = new THREE.Scene()

    Pieces3D.make_stickers(@scene)
    Positions.init()

    @alg = new Alg()
    @playing_alg = false

    this.animate()

  # this function is executed on each animation frame
  animate: ->
    if @playing_alg
      if not @move || @move.finished
        this.new_move(@alg.next_move())
        unless @move
          @playing_alg = false
    else
      user_move = @input_handler.next_move()
      if user_move
        this.new_move(user_move)
      else
        if @move && @move.finished
          @move = null # Is this a memory leak?

    if @move
      @move.animate()

    @renderer.render @scene, @camera

    # request new frame
    requestAnimationFrame => this.animate()

  new_move: (move) ->
    if @move
      @move.finish()
    @move = move

  button_click: (name) ->
    switch name
      when "forward" then @playing_alg = true
      when "pause" then @playing_alg = false
      when "back" then "TODO"
