class ConcurrentChangers
  constructor: (@sub_changers) ->

  update: (now) ->
    for changer in @sub_changers
      changer.update(now)

  finish: ->
    for changer in @sub_changers
      changer.finish()

  finished: ->
    for changer in @sub_changers
      return false unless changer.finished()
    true
