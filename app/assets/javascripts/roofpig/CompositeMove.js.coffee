#= require roofpig/Move
#= require roofpig/WorldChangers

class @CompositeMove
  constructor: (@actions, @official_text = null) ->

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
    return 1 if @official_text

    result = 0
    for action in @actions
      result += action.count()
    result

  to_s: ->
    "(#{(@actions.map (action) -> action.to_s()).join(' ')})"

  display_text: ->
    return @official_text if @official_text

    display_texts = @actions.map (action) -> action.display_text()
    (text for text in display_texts when text).join('+')
