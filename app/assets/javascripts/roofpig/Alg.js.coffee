#= require roofpig/Move

class @Alg
  constructor: (move_codes = '') ->
    @moves = move_codes.split(' ').map (code) -> Move.from_code(code)
    @next = 0
    @playing = false

  next_move: ->
    return null unless @playing

    move = @moves[@next]
    @next += 1
    return move

  start_animation: ->
    @playing = 'forward'
    return new AlgAnimation(this)

  stop: ->
    @playing = false

  to_s: ->
    (@moves.map (move) -> move.to_s()).join(' ')