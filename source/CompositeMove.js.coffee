#= require roofpig/Move
#= require roofpig/changers/ConcurrentChangers

class @CompositeMove
  constructor: (move_codes, world3d, speed, @official_text = null) ->
    @moves = (new Move(code, world3d, speed) for code in move_codes.split('+'))

  do:       -> new ConcurrentChangers( (@moves.map (move) -> move.do()) )
  undo:     -> new ConcurrentChangers( (@moves.map (move) -> move.undo()) )
  mix:      -> new ConcurrentChangers( (@moves.map (move) -> move.mix()) )
  show_do:  -> new ConcurrentChangers( (@moves.map (move) -> move.show_do()) )
  show_undo:-> new ConcurrentChangers( (@moves.map (move) -> move.show_undo()) )

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
