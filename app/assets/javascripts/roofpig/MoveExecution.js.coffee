#= require roofpig/TimedChanger

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
