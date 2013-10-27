#= require three.min
#= require roofpig/Move
#= require roofpig/Pieces3D

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Display
  constructor: ->
    @input_handler = new InputHandler(this)

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

    @alg = new Alg(canvas_div.data("alg"))
    @animations = []

    this.animate()

  # this function is executed on each animation frame
  animate: ->
    for animation in @animations
      animation.animate()

    @renderer.render @scene, @camera

    # request new frame
    requestAnimationFrame => this.animate()

  new_user_move: (move) ->
    if @user_move
      @user_move.finish()
    @user_move = move

    @animations.push(move)

  button_click: (name) ->
    switch name
      when "forward" then @animations.push(@alg.start_animation())
      when "pause" then @alg.stop()
      when "back" then "TODO"
