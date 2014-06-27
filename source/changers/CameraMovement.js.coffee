#= require roofpig/changers/TimedChanger

class @CameraMovement extends TimedChanger
  constructor: (@camera, @axis, @angle_to_turn, turn_time, animate) ->
    super(turn_time)

    unless animate
      this.finish()

  do_change: (time_diff) ->
    @camera.rotate(@axis, time_diff * @angle_to_turn / @duration)
