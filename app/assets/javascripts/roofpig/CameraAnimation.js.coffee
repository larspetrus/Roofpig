class @CameraAnimation
  constructor: (@camera, @axis, @total_angle_change, @turn_time) ->
    @start_time = (new Date()).getTime()
    @last_time = @start_time

  update: (now) ->
    return if @finished

    if now > @start_time + @turn_time
      this.finish()
    else
      this.rotate(now)

  finish: ->
    return if @finished

    this.rotate(@start_time + @turn_time)
    @finished = true

  rotate: (to_time) ->
    change = (to_time - @last_time) * @total_angle_change / @turn_time
    @last_time = to_time

    @camera.rotate(@axis, change)
