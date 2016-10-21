#= require TimedChanger

class CameraMovement extends TimedChanger
  constructor: (@camera, @axis, @angle_to_turn, turn_time, animate) ->
    super(turn_time)

    unless animate
      this.finish()

  do_change: (completion_diff) ->
    @camera.rotate(@axis, completion_diff * @angle_to_turn)

  _realign: ->
    @camera.to_position()
