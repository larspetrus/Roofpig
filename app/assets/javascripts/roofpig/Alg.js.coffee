#= require roofpig/Move

class @Alg
  constructor: (string_of_moves = 'F1 U1 F3 U1 F1 U2 F3') ->
    @moves = string_of_moves.split(' ').map (code) -> Move.from_code(code)
    @next = 0

  next_move: ->
    move = @moves[@next]
    @next += 1
    return move

  to_s: ->
    (@moves.map (move) -> move.to_s()).join(' ')