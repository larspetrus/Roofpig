#= require roofpig/Pieces3D
#= require roofpig/MoveAnimation

class @Move
  constructor: (code) ->
    [@side, @turns] = Move._parse_code(code)

    @turn_time = 150 + 150 * Math.abs(@turns)

  @_parse_code: (code) ->
    turns = switch code.substring(1)
      when "1", ""   then 1
      when "2", "²"  then 2
      when "3", "'"  then -1
      when "Z", "2'" then -2
    [Side.by_name(code[0]), turns]

  do: (pieces3d) ->
    this._do(pieces3d, @turns, false)

  undo: (pieces3d) ->
    this._do(pieces3d, -@turns, false)

  show_do: (pieces3d) ->
    this._do(pieces3d, @turns, true)

  show_undo: (pieces3d) ->
    this._do(pieces3d, -@turns, true)

  _do: (pieces3d, do_turns, animate) ->
    animation_pieces = pieces3d.on(@side)
    pieces3d.move(@side, do_turns)
    new MoveAnimation(animation_pieces, @side.normal, do_turns * -Math.PI/2, @turn_time, animate)


  to_s: ->
    turn_code = switch @turns
      when  1 then ""
      when  2 then "2"
      when -1 then "'"
      when -2 then "Z"

    "#{@side.name}#{turn_code}"
