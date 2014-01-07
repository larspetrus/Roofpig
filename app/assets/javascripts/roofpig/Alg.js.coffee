#= require roofpig/Move
#= require roofpig/Rotation
#= require roofpig/CompositeMove

class @Alg
  constructor: (move_codes, @dom_handler) ->
    if not move_codes || move_codes == ""
      throw new Error("Invalid alg: '#{move_codes}'")

    @actions = []
    for code in move_codes.split(' ')
      if code.length > 0
        @actions.push(Alg._make_action(code))
    @next = 0
    @playing = false
    this._update_dom('first time')

  @_make_action: (code) ->
    if code.indexOf('+') > -1
      moves = (code.split('+').map (code) -> Alg._make_action(code))
      new CompositeMove(moves)
    else
      if code.indexOf('>') > -1 || code.indexOf('<') > -1
        new Rotation(code)
      else
        new Move(code)


  premix: (world3d) ->
    @next =  @actions.length
    until this.at_start()
      this.prev_move().undo(world3d)
    this

  next_move: ->
    unless this.at_end()
      @next += 1
      if this.at_end() then @playing = false
      this._update_dom()
      @actions[@next-1]

  prev_move: ->
    unless this.at_start()
      @next -= 1
      this._update_dom()
      @actions[@next]

  play: (world3d) ->
    @playing = true
    this._update_dom()
    new AlgAnimation(this, world3d)

  stop: ->
    @playing = false
    this._update_dom()

  at_start: ->
    @next == 0

  at_end: ->
    @next == @actions.length

  to_s: ->
    (@actions.map (move) -> move.to_s()).join(' ')

  standard_text: ->
    printables = []
    for action in @actions
      if action.standard_text()
        printables.push(action.standard_text())
    printables.join(' ')

  _update_dom: (time = 'later') ->
    return unless @dom_handler

    if time == 'first time'
      @dom_handler.init_alg_text(this.standard_text())

    @dom_handler.alg_changed(@playing, this.at_start(), this.at_end(), this._place_text())

  _place_text: ->
    total = current = 0
    for move, i in @actions
      current += move.count() if @next > i
      total += move.count()
    "#{current}/#{total}"