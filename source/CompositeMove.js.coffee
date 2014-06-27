#= require roofpig/Move
#= require roofpig/changers/ConcurrentChangers

class @CompositeMove
  constructor: (@moves, @official_text = null) ->

  do: ->
    new ConcurrentChangers( (@moves.map (move) -> move.do()) )

  undo: ->
    new ConcurrentChangers( (@moves.map (move) -> move.undo()) )

  premix: ->
    new ConcurrentChangers( (@moves.map (move) -> move.premix()) )

  show_do: ->
    new ConcurrentChangers( (@moves.map (move) -> move.show_do()) )

  show_undo: ->
    new ConcurrentChangers( (@moves.map (move) -> move.show_undo()) )

  count: (count_rotations) ->
    return 1 if @official_text

    result = 0
    for move in @moves
      result += move.count(count_rotations)
    result

  to_s: ->
    "(#{(@moves.map (move) -> move.to_s()).join(' ')})"

  display_text: (algdisplay) ->
    if @official_text
      return Move.displayify(@official_text, algdisplay)

    display_texts = @moves.map (move) -> move.display_text(algdisplay)
    (text for text in display_texts when text).join('+')
