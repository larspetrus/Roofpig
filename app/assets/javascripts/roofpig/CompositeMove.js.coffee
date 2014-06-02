#= require roofpig/Move
#= require roofpig/WorldChangers

class @CompositeMove
  constructor: (@actions) ->

  do: (world3d) ->
    new ConcurrentChangers( (@actions.map (action) -> action.do(world3d)) )

  undo: (world3d) ->
    new ConcurrentChangers( (@actions.map (action) -> action.undo(world3d)) )

  premix: (world3d) ->
    new ConcurrentChangers( (@actions.map (action) -> action.premix(world3d)) )

  show_do: (world3d) ->
    new ConcurrentChangers( (@actions.map (action) -> action.show_do(world3d)) )

  show_undo: (world3d) ->
    new ConcurrentChangers( (@actions.map (action) -> action.show_undo(world3d)) )

  count: ->
    result = 0
    for action in @actions
      result += action.count()
    result

  to_s: ->
    "(#{(@actions.map (action) -> action.to_s()).join(' ')})"

  standard_text: ->
    printables = []
    for action in @actions
      if action.standard_text()
        printables.push(action.standard_text())
    printables.join('+')
