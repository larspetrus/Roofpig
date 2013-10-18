#= require roofpig/Positions

class @Move
  constructor: (@side, @turns) ->
    @turn_time = [300, 450, 300][@turns-1] #ms
    @start_time = (new Date()).getTime()
    @last_time = @start_time
    q_turn = - Math.PI / 2
    @total_angle_change = [q_turn, 2 *q_turn, -q_turn][@turns-1]

  animate: ->
    return if @finished

    @pieces ?= Positions.for_side(@side.name)

    now = (new Date()).getTime()
    if now > @start_time + @turn_time
      this.finish()
    else
      this.rotate(now)

  finish:->
    return if @finished

    this.rotate(@start_time + @turn_time)

    Positions.u_move(@turns)  if @side == Side.U
    Positions.d_move(@turns)  if @side == Side.D
    Positions.f_move(@turns)  if @side == Side.F
    Positions.b_move(@turns)  if @side == Side.B
    Positions.l_move(@turns)  if @side == Side.L
    Positions.r_move(@turns)  if @side == Side.R

    #    Positions.print()
    @finished = true

  # Rotate an object around an arbitrary axis in world space #adapted from http://stackoverflow.com/questions/11119753/how-to-rotate-a-object-on-axis-world-three-js
  rotateAroundWorldAxis: (object, axis, radians) ->
    rotWorldMatrix = new THREE.Matrix4()
    rotWorldMatrix.makeRotationAxis(axis.normalize(), radians)
    rotWorldMatrix.multiply(object.matrix) # pre-multiply
    object.matrix = rotWorldMatrix
    object.rotation.setFromRotationMatrix(object.matrix)

  rotate: (to_time) ->
    change = (to_time - @last_time) * @total_angle_change / @turn_time
    @last_time = to_time

    for piece in @pieces
      this.rotateAroundWorldAxis(piece, @side.normal, change)
