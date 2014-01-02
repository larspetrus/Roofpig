class @TimedChanger
  constructor: (@duration) ->
    @start_time = (new Date()).getTime()
    @last_time = @start_time

  update: (now) ->
    return if @_finished

    if now > @start_time + @duration
      this.finish()
    else
      this._make_change(now)

  finish: ->
    return if @_finished

    this._make_change(@start_time + @duration)
    @_finished = true

  finished: ->
    @_finished

  _make_change: (to_time) ->
    this.do_change(to_time - @last_time)
    @last_time = to_time
