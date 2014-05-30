#= require roofpig/MoveExecution
#= require roofpig/Side

class @Move
  constructor: (code) ->
    [@side, @turns] = Move._parse_code(code)

    @turn_time = 200 * (1 + Math.abs(@turns))

  @_parse_code: (code) ->
    turns = switch code.substring(1)
      when "1", ""   then 1
      when "2", "²"  then 2
      when "3", "'"  then -1
      when "Z", "2'" then -2
    unless (side = Side.by_name(code[0])) && turns
      throw new Error("Invalid Move code '#{code}'")
    [side, turns]

  do: (world3d) ->
    this._do(world3d.pieces, @turns, false)

  undo: (world3d) ->
    this._do(world3d.pieces, -@turns, false)

  premix: (world3d) ->
    this.undo(world3d)

  show_do: (world3d) ->
    this._do(world3d.pieces, @turns, true)

  show_undo: (world3d) ->
    this._do(world3d.pieces, -@turns, true)

  _do: (pieces3d, do_turns, animate) ->
    pieces3d.move(@side, do_turns)
    new MoveExecution(pieces3d.on(@side), @side.normal, do_turns * -Math.PI/2, @turn_time, animate)

  count: -> 1

  to_s: ->
    turn_code = switch @turns
      when  1 then ""
      when  2 then "2"
      when -1 then "'"
      when -2 then "Z"

    "#{@side.name}#{turn_code}"

  standard_text: ->
    this.to_s().replace('Z', '2')