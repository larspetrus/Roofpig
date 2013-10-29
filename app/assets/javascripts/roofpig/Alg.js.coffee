#= require roofpig/Move

class @Alg
  constructor: (move_codes = '') ->
    @moves = move_codes.split(' ').map (code) -> Move.from_code(code)
    @next = 0
    @playing = false

  next_move: ->
    unless this.at_end()
      @next += 1
      @moves[@next-1].do()

  prev_move: ->
    unless this.at_start()
      @next -= 1
      @moves[@next].undo()

  play: (display) ->
    @playing = true
    new AlgAnimation(this, display)

  at_start: ->
    @next == 0

  at_end: ->
    @next == @moves.length

  stop: ->
    @playing = false

  to_s: ->
    (@moves.map (move) -> move.to_s()).join(' ')