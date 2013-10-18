#= require three.min
#= require roofpig/Move
#= require roofpig/Pieces
#= require roofpig/Positions
#= require roofpig/Side

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Display
  constructor: ->
    @input_handler = new InputHandler()

    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize window.innerWidth, window.innerHeight
    document.body.appendChild @renderer.domElement

    @camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 100)
    @camera.position.y = 22
    @camera.position.z = 20
    @camera.position.x = 10
    @camera.lookAt(v3(0, 0, 0))
    @camera.rotation.z = Math.PI

    @scene = new THREE.Scene()

    Pieces3D.make_stickers(@scene)
    Positions.init()

    this.animate()

  # this function is executed on each animation frame
  animate: ->
    key_event = @input_handler.next_key()

    if key_event && key_event.key in ['U', 'D', 'F', 'B', 'L', 'R']
      if key_event.shift
        turns = 3
      else if key_event.ctrl
        turns = 2
      else
        turns = 1

      this.new_move(new Move(Side.by_name(key_event.key), turns))

    @move.animate() if @move

    @renderer.render @scene, @camera

    # request new frame
    requestAnimationFrame =>
      this.animate()

  new_move: (move) ->
    if @move
      @move.finish()
    @move = move
