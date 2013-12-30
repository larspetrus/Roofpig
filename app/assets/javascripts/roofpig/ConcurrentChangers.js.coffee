class @ConcurrentChangers
  constructor: (@changers) ->

  update: (now) ->
    for changer in @changers
      changer.update(now)

  finish: ->
    for changer in @changers
      changer.finish()
