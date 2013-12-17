class @TimedChanger
  constructor: (@duration) ->
    @start_time = (new Date()).getTime()
    @last_time = @start_time

  update: (now) ->
    return if @finished

    if now > @start_time + @duration
      this.finish()
    else
      this._make_change(now)

  finish: ->
    return if @finished

    this._make_change(@start_time + @duration)
    @finished = true

  _make_change: (to_time) ->
    this.do_change(to_time - @last_time)
    @last_time = to_time
