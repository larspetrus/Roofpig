# Does a single immediate change
class OneChange
  constructor: (@action) ->

  update: (now) ->
    @action()

  finish: ->

  finished: ->
    true
