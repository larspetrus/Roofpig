#= require Move
#= require AlgAnimation

class Alg
  constructor: (@move_codes, @world3d, @algdisplay, @speed, @dom) ->
    @moves = []
    for code in @move_codes.split(' ')
      if code.length > 0
        @moves.push(Move.make(code, @world3d, @speed))
    @next = 0
    @playing = false
    this._update_dom('first time')

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

  play: ->
    @playing = true
    this._update_dom()
    new AlgAnimation(this)

  stop: ->
    @playing = false
    this._update_dom()

  to_end: ->
    until this.at_end()
      this.next_move().do()

  to_start: ->
    until this.at_start()
      this.prev_move().undo()

  at_start: ->
    @next == 0

  at_end: ->
    @next == @moves.length

  mix: ->
    @next =  @moves.length
    until this.at_start()
      this.prev_move().mix()

  to_s: ->
    (@moves.map (move) -> move.to_s()).join(' ')

  display_text: ->
    active = past = []
    future = []
    for move, i in @moves
      if @next == i then active = future
      text = move.display_text(@algdisplay)
      if text
        active.push(text)
    { past: past.join(' '), future: future.join(' ')}

  # Translate "hand" moves to BRDFLU
  unhand: ->
    pov = new PovTracker()
    result = []
    for move in @moves
      result.push(pov.hand_to_cube(move.as_brdflu()))
      pov.track(move)
    result.join(' ').replace(/[ ]+/g, ' ').replace(/^ +| +$/g, '')

  @pov_from: (move_codes) ->
    new PovTracker(new Alg(move_codes).moves)

  _update_dom: (time = 'later') ->
    if @dom && @moves.length > 0
      if time == 'first time'
        @dom.init_alg_text(this.display_text().future)

      @dom.alg_changed(@playing, this.at_start(), this.at_end(), this._count_text(), this.display_text())

  _count_text: ->
    total = current = 0
    for move, i in @moves
      count = move.count(@algdisplay.rotations)
      current += count if @next > i
      total += count
    "#{current}/#{total}"