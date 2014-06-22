#= require roofpig/Move
#= require roofpig/WorldChangers

class @CompositeMove
  constructor: (@actions, @official_text = null) ->

  do: ->
    new ConcurrentChangers( (@actions.map (action) -> action.do()) )

  undo: ->
    new ConcurrentChangers( (@actions.map (action) -> action.undo()) )

  premix: ->
    new ConcurrentChangers( (@actions.map (action) -> action.premix()) )

  show_do: ->
    new ConcurrentChangers( (@actions.map (action) -> action.show_do()) )

  show_undo: ->
    new ConcurrentChangers( (@actions.map (action) -> action.show_undo()) )

  count: (count_rotations) ->
    return 1 if @official_text

    result = 0
    for action in @actions
      result += action.count(count_rotations)
    result

  to_s: ->
    "(#{(@actions.map (action) -> action.to_s()).join(' ')})"

  display_text: (algdisplay) ->
    if @official_text
      return Move.displayify(@official_text, algdisplay)

    display_texts = @actions.map (action) -> action.display_text(algdisplay)
    (text for text in display_texts when text).join('+')
