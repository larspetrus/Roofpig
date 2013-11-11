#= require roofpig/Move

class @Alg
  constructor: (move_codes, @dom_handler) ->
    if not move_codes || move_codes == ""
      throw new Error("Invalid alg: '#{move_codes}'")

    console.log(move_codes.split(' '))

    @moves = []
    for code in move_codes.split(' ')
      if code.length > 0
        @moves.push(new Move(code))
    @next = 0
    @playing = false
    this._update_buttons()

  premix: (pieces3d) ->
    @next =  @moves.length
    until this.at_start()
      this.prev_move().undo(pieces3d).finish()
    this

  next_move: ->
    unless this.at_end()
      @next += 1
      if this.at_end() then @playing = false
      this._update_buttons()
      @moves[@next-1]

  prev_move: ->
    unless this.at_start()
      @next -= 1
      this._update_buttons()
      @moves[@next]

  play: (pieces3d) ->
    @playing = true
    this._update_buttons()
    new AlgAnimation(this, pieces3d)

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
    @dom_handler.alg_changed(@playing, this.at_start(), this.at_end(), "#{@next}/#{@moves.length}")