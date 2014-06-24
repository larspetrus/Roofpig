# Any change to the world (3D model or camera) must be done with a Changer object.
#
# Changers must implement 3 functions
# - update: (now) ->
#     Performs a change, possibly based on time.
# - finish: ->
#     Finish this Changer, probably since a new one has arrived.
# - finished: ->
#     Returns true if this Changer is done.



class @TimedChanger # Base class
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
    unless this.finished()
      this._make_change(@start_time + @duration)
      @_finished = true

  finished: ->
    @_finished

  _make_change: (to_time) ->
    this.do_change(to_time - @last_time)
    @last_time = to_time
