class @ConcurrentChangers
  constructor: (@changers) ->

  update: (now) ->
    for changer in @changers
      changer.update(now)

  finish: ->
    for changer in @changers
      changer.finish()

  finished: ->
    for changer in @changers
      return false unless changer.finished()
    true
