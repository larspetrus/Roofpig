#= require roofpig/Layer
#= require roofpig/changers/MoveExecution

class @Move
  constructor: (code, @world3d, @speed = 200) ->
    [@layer, @turns] = Move._parse_code(code)

    @turn_time = @speed * (1 + Math.abs(@turns))

  @_parse_code: (code) ->
    turns = Move.parse_turns(code.substring(1))
    side = Layer.by_name(code[0])
    unless side && turns
      throw new Error("Invalid Move code '#{code}'")
    [side, turns]

  @parse_turns: (tcode) ->
    switch tcode
      when "1", ""   then 1
      when "2", "²"  then 2
      when "3", "'"  then -1
      when "Z", "2'" then -2

  do: ->
    this._do(@turns, false)

  undo: ->
    this._do(-@turns, false)

  premix: ->
    this.undo()

  show_do: ->
    this._do(@turns, true)

  show_undo: ->
    this._do( -@turns, true)

  _do: (do_turns, animate) ->
    @world3d.pieces.move(@layer, do_turns)
    new MoveExecution(@world3d.pieces.on(@layer), @layer.normal, do_turns * -Math.PI/2, @turn_time, animate)

  count: (count_rotations) -> 1

  to_s: ->
    turn_code = switch @turns
      when  1 then ""
      when  2 then "2"
      when -1 then "'"
      when -2 then "Z"

    "#{@layer.name}#{turn_code}"

  @displayify: (move_text, algdisplay) ->
    result = move_text.replace('Z', algdisplay.Zcode)
    result = result.replace('2', '²') if algdisplay.fancy2s
    result

  display_text: (algdisplay) ->
    Move.displayify(this.to_s(), algdisplay)
