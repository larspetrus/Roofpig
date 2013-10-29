#= require roofpig/Move

class @Alg
  constructor: (move_codes = '') ->
    @moves = move_codes.split(' ').map (code) -> Move.from_code(code)
    @next = 0
    @playing = false

  next_move: (display) ->
    move = @moves[@next]
    if move
      @next += 1
      mv_anim = move.do()
      display.new_single_move(mv_anim)
      mv_anim
    else
      this.stop()

  prev_move: (display) ->
    move = @moves[@next - 1]
    if move
      @next -= 1
      if display
        display.new_single_move(move.undo())
      else
        move.undo().finish()

  play: (display) ->
    @playing = true
    new AlgAnimation(this, display)

  at_start: ->
    @next == 0

  stop: ->
    @playing = false

  to_s: ->
    (@moves.map (move) -> move.to_s()).join(' ')