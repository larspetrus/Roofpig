#= require roofpig/Side

class @Rotation
  constructor: (code) ->
    [@side, @turns] = Rotation._parse_code(code)

    @turn_time = 120 * (1 + Math.abs(@turns))

  @_parse_code: (code) ->
    turns = switch code.substring(1)
      when ">"   then 1
      when ">>"  then 2
      when "<"  then -1
      when "<<" then -2
    [Side.by_name(code[0]), turns]

  do: (world) ->
    this._do(world.camera, @turns, false)

  undo: (world) ->
    this._do(world.camera, -@turns, false)

  show_do: (world) ->
    this._do(world.camera, @turns, true)

  show_undo: (world) ->
    this._do(world.camera, -@turns, true)

  _do: (camera, do_turns, animate) ->
    # TODO How does this work in premix and reset?
    new CameraMovement(camera, @side.normal, do_turns * Math.PI/2, @turn_time) #, animate)

  count: -> 0

  to_s: ->
    turn_code = switch @turns
      when  1 then ">"
      when  2 then ">>"
      when -1 then "<"
      when -2 then "<<"

    "#{@side.name}#{turn_code}"
