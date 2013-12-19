#= require roofpig/Move

class @Alg
  constructor: (move_codes, @dom_handler) ->
    if not move_codes || move_codes == ""
      throw new Error("Invalid alg: '#{move_codes}'")

    @moves = []
    for code in move_codes.split(' ')
      if code.length > 0
        @moves.push(new Move(code))
    @next = 0
    @playing = false
    this._update_dom(true)

  premix: (pieces3d) ->
    @next =  @moves.length
    until this.at_start()
      this.prev_move().undo(pieces3d)
    this

  next_move: ->
    unless this.at_end()
      @next += 1
      if this.at_end() then @playing = false
      this._update_dom()
      @moves[@next-1]

  prev_move: ->
    unless this.at_start()
      @next -= 1
      this._update_dom()
      @moves[@next]

  play: (pieces3d) ->
    @playing = true
    this._update_dom()
    new AlgAnimation(this, pieces3d)

  stop: ->
    @playing = false
    this._update_dom()

  at_start: ->
    @next == 0

  at_end: ->
    @next == @moves.length

  to_s: ->
    (@moves.map (move) -> move.to_s()).join(' ')

  _update_dom: (first_time = false) ->
    return unless @dom_handler

    if first_time
      @dom_handler.init_alg_text(this.to_s())

    @dom_handler.alg_changed(@playing, this.at_start(), this.at_end(), "#{@next}/#{@moves.length}")