#= require roofpig/Layer

class @Rotation
  constructor: (code, @world3d, @speed = 200) ->
    [@layer, @turns] = Rotation._parse_code(code)

    @turn_time = @speed * (1 + Math.abs(@turns))

  @_parse_code: (code) ->
    turns = switch code.substring(1)
      when ">"   then 1
      when ">>"  then 2
      when "<"  then -1
      when "<<" then -2
    unless (layer = Layer.side_by_name(code[0])) && turns
      throw new Error("Invalid Rotation code '#{code}'")
    [layer, turns]

  do: ->
    this._do(@turns, false)

  undo: ->
    this._do(-@turns, false)

  premix: ->
    # No Rotations in premix

  show_do: ->
    this._do(@turns, true)

  show_undo: ->
    this._do(-@turns, true)

  _do: (do_turns, animate) ->
    new CameraMovement(@world3d.camera, @layer.normal, do_turns * Math.PI/2, @turn_time, animate)

  count: (count_rotations) ->
    if count_rotations
      1
    else
      0

  to_s: ->
    turn_code = switch @turns
      when  1 then ">"
      when  2 then ">>"
      when -1 then "<"
      when -2 then "<<"

    "#{@layer.name}#{turn_code}"

  display_text: (algdisplay) ->
    if algdisplay.rotations
      this.to_s()
    else
      ''