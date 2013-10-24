#= require roofpig/Positions

class @Move
  @from_code: (code) ->
    side = Side.by_name(code[0])
    turn_code = code[1] || '1'
    if turn_code == "'"
      turn_code = '3'
    new Move(side, parseInt(turn_code))

  constructor: (@side, @turns) ->
    @turn_time = [300, 450, 300][@turns-1] #ms
    q_turn = -Math.PI/2
    @total_angle_change = [q_turn, 2*q_turn, -q_turn][@turns-1]

  animate: ->
    return if @finished

    unless @pieces
      @pieces = Positions.for_side(@side.name)
      @start_time = (new Date()).getTime()
      @last_time = @start_time

    now = (new Date()).getTime()
    if now > @start_time + @turn_time
      this.finish()
    else
      this.rotate(now)

  finish: ->
    return if @finished

    this.rotate(@start_time + @turn_time)
    Positions.move_pieces(@side, @turns)
    @finished = true

  to_s: ->
    "#{@side.name}#{@turns}"

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
