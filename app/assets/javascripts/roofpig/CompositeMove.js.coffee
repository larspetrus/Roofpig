#= require roofpig/Move
#= require roofpig/ConcurrentChangers

class @CompositeMove
  constructor: (@moves) ->

  do: (pieces3d) ->
    new ConcurrentChangers( (@moves.map (move) -> move.do(pieces3d)) )

  undo: (pieces3d) ->
    new ConcurrentChangers( (@moves.map (move) -> move.undo(pieces3d)) )

  show_do: (pieces3d) ->
    new ConcurrentChangers( (@moves.map (move) -> move.show_do(pieces3d)) )

  show_undo: (pieces3d) ->
    new ConcurrentChangers( (@moves.map (move) -> move.show_undo(pieces3d)) )

  to_s: ->
    "(#{(@moves.map (move) -> move.to_s()).join(' ')})"
