#= require roofpig/Move
#= require roofpig/ConcurrentChangers

class @CompositeMove
  constructor: (@moves) ->

  do: (world) ->
    new ConcurrentChangers( (@moves.map (move) -> move.do(world)) )

  undo: (world) ->
    new ConcurrentChangers( (@moves.map (move) -> move.undo(world)) )

  show_do: (world) ->
    new ConcurrentChangers( (@moves.map (move) -> move.show_do(world)) )

  show_undo: (world) ->
    new ConcurrentChangers( (@moves.map (move) -> move.show_undo(world)) )

  count: ->
    result = 0
    for move in @moves
      result += move.count()
    result

  to_s: ->
    "(#{(@moves.map (move) -> move.to_s()).join(' ')})"
