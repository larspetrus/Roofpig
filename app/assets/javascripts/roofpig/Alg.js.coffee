#= require roofpig/Move
#= require roofpig/CompositeMove

class @Alg
  constructor: (move_codes, @dom_handler) ->
    if not move_codes || move_codes == ""
      throw new Error("Invalid alg: '#{move_codes}'")

    @moves = []
    for code in move_codes.split(' ')
      if code.length > 0
        if code.indexOf('+') > -1
          moves = (code.split('+').map (code) -> new Move(code))
          @moves.push(new CompositeMove(moves))
        else
          @moves.push(new Move(code))
    @next = 0
    @playing = false
    this._update_dom('first time')

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

  _update_dom: (time = 'later') ->
    return unless @dom_handler

    if time == 'first time'
      @dom_handler.init_alg_text(this.to_s())

    @dom_handler.alg_changed(@playing, this.at_start(), this.at_end(), this._place_text())

  _place_text: ->
    total = current = 0
    for move, i in @moves
      current += move.count() if @next > i
      total += move.count()
    "#{current}/#{total}"