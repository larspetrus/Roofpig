#= require roofpig/Move
#= require roofpig/ConcurrentChangers

class @CompositeMove
  constructor: (@moves) ->

  do: (world3d) ->
    new ConcurrentChangers( (@moves.map (move) -> move.do(world3d)) )

  undo: (world3d) ->
    new ConcurrentChangers( (@moves.map (move) -> move.undo(world3d)) )

  show_do: (world3d) ->
    new ConcurrentChangers( (@moves.map (move) -> move.show_do(world3d)) )

  show_undo: (world3d) ->
    new ConcurrentChangers( (@moves.map (move) -> move.show_undo(world3d)) )

  count: ->
    result = 0
    for move in @moves
      result += move.count()
    result

  to_s: ->
    "(#{(@moves.map (move) -> move.to_s()).join(' ')})"

  standard_text: ->
    printables = []
    for action in @moves
      if action.standard_text()
        printables.push(action.standard_text())
    printables.join('+')
