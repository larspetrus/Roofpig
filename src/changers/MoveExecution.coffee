#= require TimedChanger

class MoveExecution extends TimedChanger
  constructor: (@pieces, @axis, @angle_to_turn, turn_time, animate) ->
    super(turn_time)

    unless animate
      this.finish()

  do_change: (completion_diff) ->
    for piece in @pieces
      this._rotateAroundWorldAxis(piece, completion_diff * @angle_to_turn)

  # Rotate an object around an arbitrary axis in world space #adapted from http://stackoverflow.com/questions/11119753/how-to-rotate-a-object-on-axis-world-three-js
  _rotateAroundWorldAxis: (object, radians) ->
    rotWorldMatrix = new THREE.Matrix4()
    rotWorldMatrix.makeRotationAxis(@axis, radians)
    rotWorldMatrix.multiply(object.matrix) # pre-multiply

    object.matrix = rotWorldMatrix
    object.rotation.setFromRotationMatrix(object.matrix)

  _realign: ->
    p2 = Math.PI / 2
    for piece in @pieces
      r = piece.rotation
      [r.x, r.y, r.z] = [Math.round(r.x / p2) * p2, Math.round(r.y / p2) * p2, Math.round(r.z / p2) * p2]

