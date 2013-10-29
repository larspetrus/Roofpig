#= require roofpig/Move

class @Alg
  constructor: (move_codes, @buttons) ->
    @moves = move_codes.split(' ').map (code) -> Move.from_code(code)
    @next = 0
    @playing = false
    this._update_buttons()

  next_move: ->
    unless this.at_end()
      @next += 1
      if this.at_end() then @playing = false
      this._update_buttons()
      @moves[@next-1].do()

  prev_move: ->
    unless this.at_start()
      @next -= 1
      this._update_buttons()
      @moves[@next].undo()

  play: (display) ->
    @playing = true
    this._update_buttons()
    new AlgAnimation(this, display)

  stop: ->
    @playing = false
    this._update_buttons()

  at_start: ->
    @next == 0

  at_end: ->
    @next == @moves.length

  to_s: ->
    (@moves.map (move) -> move.to_s()).join(' ')

  _update_buttons: ->
    @buttons.update(@playing, this.at_start(), this.at_end())