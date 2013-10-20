#= require three.min
#= require roofpig/Move
#= require roofpig/Pieces3D
#= require roofpig/Positions

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Display
  constructor: ->
    @input_handler = new InputHandler()

    @renderer = new THREE.WebGLRenderer({ antialias: true})
    @renderer.setSize(500, 500)
    @renderer.setClearColor(0xAAAAAA, 1);
    document.body.appendChild(@renderer.domElement)

    @camera = new THREE.PerspectiveCamera(24, 1, 1, 100)
    @camera.position.set(25, 25, 25)
    @camera.up.set(0,0,1);
    @camera.lookAt(v3(0, 0, 0))

    @scene = new THREE.Scene()

    Pieces3D.make_stickers(@scene)
    Positions.init()

    this.animate()

  # this function is executed on each animation frame
  animate: ->
    next_move = @input_handler.next_move()

    if next_move
      this.new_move(next_move)

    @move.animate() if @move

    @renderer.render @scene, @camera

    # request new frame
    requestAnimationFrame =>
      this.animate()

  new_move: (move) ->
    if @move
      @move.finish()
    @move = move
