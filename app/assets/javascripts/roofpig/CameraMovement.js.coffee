#= require roofpig/TimedChanger

class @CameraMovement extends TimedChanger
  constructor: (@camera, @axis, @angle_to_turn, turn_time) ->
    super(turn_time)

  do_change: (time_diff) ->
    @camera.rotate(@axis, time_diff * @angle_to_turn / @duration)
