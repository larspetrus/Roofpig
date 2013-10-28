#= require roofpig/Pieces3D

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

  do: ->
    animation_pieces = Pieces3D.on(@side)
    Pieces3D.move(@side, @turns)
    new MoveAnimation(animation_pieces, @side, @total_angle_change, @turn_time)

  undo: ->
    animation_pieces = Pieces3D.on(@side)
    Pieces3D.move(@side, 4 - @turns)
    new MoveAnimation(animation_pieces, @side, -@total_angle_change, @turn_time)

  to_s: ->
    "#{@side.name}#{@turns}"
