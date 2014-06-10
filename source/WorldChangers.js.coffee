# Anything that changes the world (3D model or camera) must be done with a Changer object.
#
# Changers must implement 3 functions
# - update: (now) ->
#     Performs a change, possibly based on time.
# - finish: ->
#     Finish the entire change, since a new one has arrived.
# - finished: ->
#     Returns true if this Changer is done.



class @TimedChanger # Base class
  constructor: (@duration) ->
    @start_time = (new Date()).getTime()
    @last_time = @start_time

  update: (now) ->
    return if @_finished

    if now > @start_time + @duration
      this.finish()
    else
      this._make_change(now)

  finish: ->
    unless this.finished()
      this._make_change(@start_time + @duration)
      @_finished = true

  finished: ->
    @_finished

  _make_change: (to_time) ->
    this.do_change(to_time - @last_time)
    @last_time = to_time



class @MoveExecution extends TimedChanger
  constructor: (@pieces, @axis, @angle_to_turn, turn_time, animate) ->
    super(turn_time)

    unless animate
      this.finish()

  do_change: (time_diff) ->
    angle_diff = time_diff * @angle_to_turn / @duration

    for piece in @pieces
      this._rotateAroundWorldAxis(piece, angle_diff)

  # Rotate an object around an arbitrary axis in world space #adapted from http://stackoverflow.com/questions/11119753/how-to-rotate-a-object-on-axis-world-three-js
  _rotateAroundWorldAxis: (object, radians) ->
    rotWorldMatrix = new THREE.Matrix4()
    rotWorldMatrix.makeRotationAxis(@axis, radians)
    rotWorldMatrix.multiply(object.matrix) # pre-multiply

    object.matrix = rotWorldMatrix
    object.rotation.setFromRotationMatrix(object.matrix)



class @CameraMovement extends TimedChanger
  constructor: (@camera, @axis, @angle_to_turn, turn_time, animate) ->
    super(turn_time)

    unless animate
      this.finish()

  do_change: (time_diff) ->
    @camera.rotate(@axis, time_diff * @angle_to_turn / @duration)



class @ConcurrentChangers
  constructor: (@sub_changers) ->

  update: (now) ->
    for changer in @sub_changers
      changer.update(now)

  finish: ->
    for changer in @sub_changers
      changer.finish()

  finished: ->
    for changer in @sub_changers
      return false unless changer.finished()
    true



class @AlgAnimation
  constructor: (@alg, @world3d) ->
    this._next_alg_move()

  update: (now) ->
    return if @_finished

    if @changer.finished()
      this._next_alg_move()

    @changer.update(now)

  finish: ->
    # API creep

  finished: ->
    @_finished

  _next_alg_move: ->
    if @alg.at_end() || not @alg.playing
      @_finished = true
    else
      @changer = @alg.next_move().show_do(@world3d)



class @OneChange
  constructor: (@action) ->

  update: (now) ->
    @action()

  finish: ->

  finished: ->
    true
