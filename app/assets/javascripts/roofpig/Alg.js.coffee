#= require roofpig/Move

class @Alg
  constructor: (move_codes = '') ->
    @moves = move_codes.split(' ').map (code) -> Move.from_code(code)
    @next = 0

  next_move: ->
    move = @moves[@next]
    @next += 1
    return move

  to_s: ->
    (@moves.map (move) -> move.to_s()).join(' ')