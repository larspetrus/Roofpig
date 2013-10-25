class @MoveAnimation
  constructor: (@pieces, @side, @total_angle_change, @turn_time) ->
    @start_time = (new Date()).getTime()
    @last_time = @start_time

  animate: ->
    return if @finished

    now = (new Date()).getTime()
    if now > @start_time + @turn_time
      this.finish()
    else
      this.rotate(now)

  finish: ->
    return if @finished

    this.rotate(@start_time + @turn_time)
    @finished = true

  # Rotate an object around an arbitrary axis in world space #adapted from http://stackoverflow.com/questions/11119753/how-to-rotate-a-object-on-axis-world-three-js
  _rotateAroundWorldAxis: (object, axis, radians) ->
    rotWorldMatrix = new THREE.Matrix4()
    rotWorldMatrix.makeRotationAxis(axis.normalize(), radians)
    rotWorldMatrix.multiply(object.matrix) # pre-multiply
    object.matrix = rotWorldMatrix
    object.rotation.setFromRotationMatrix(object.matrix)

  rotate: (to_time) ->
    change = (to_time - @last_time) * @total_angle_change / @turn_time
    @last_time = to_time

    for piece in @pieces
      this._rotateAroundWorldAxis(piece, @side.normal, change)
