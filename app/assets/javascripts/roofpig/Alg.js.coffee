#= require roofpig/Move
#= require roofpig/Rotation
#= require roofpig/CompositeMove

class @Alg
  constructor: (@move_codes, @dom_handler) ->
    if not @move_codes || @move_codes == ""
      throw new Error("Invalid alg: '#{@move_codes}'")
    this._pre_process()

    @actions = []
    for code in @move_codes.split(' ')
      if code.length > 0
        @actions.push(Alg._make_action(code))
    @next = 0
    @playing = false
    this._update_dom('first time')

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

  to_end: (world3d) ->
    until this.at_end()
      this.next_move().do(world3d)

  to_start: (world3d) ->
    until this.at_start()
      this.prev_move().undo(world3d)

  at_start: ->
    @next == 0

  at_end: ->
    @next == @actions.length

  premix: (world3d) ->
    @next =  @actions.length
    until this.at_start()
      this.prev_move().premix(world3d)
    this

  to_s: ->
    (@actions.map (move) -> move.to_s()).join(' ')

  display_text: ->
    active = past = []
    future = []
    for action, i in @actions
      if @next == i then active = future
      if action.display_text()
        active.push(action.display_text())
    { past: past.join(' '), future: future.join(' ')}

  _pre_process: ->
    switch @move_codes.substring(0, 6)
      when 'shift>' then shift = 1
      when 'shift2' then shift = 2
      when 'shift<' then shift = 3

    if shift
      shifted_codes = ""
      for char in @move_codes.substring(6).split('')
        if char in ['M','E','S','x','y','z']
          throw new Error("M, E, S, x, y or z can't be shifted.")
        shifted_codes += Layer.D.shift(char, shift) || char
      @move_codes = shifted_codes

  @_make_action: (code) ->
    if code.indexOf('+') > -1
      moves = (Alg._make_action(code) for code in code.split('+'))
      new CompositeMove(moves)

    else if code[0] in ['x', 'y', 'z']
      turns = Move.parse_turns(code.substring(1))
      [t1, t2] = {'-2': ['Z', '2'], '-1':["'", ''], 1:['', "'"], 2: ['2', 'Z']}[turns]
      moves = switch code[0]
        when 'x' then [new Move("R"+t1), new Move("M"+t2), new Move("L"+t2)]
        when 'y' then [new Move("U"+t1), new Move("E"+t2), new Move("D"+t2)]
        when 'z' then [new Move("F"+t1), new Move("S"+t1), new Move("B"+t2)]
      new CompositeMove(moves, code)

    else if code[1] == 'w' && code[0] in ['U', 'D', 'L', 'R', 'F', 'B']
      turns = Move.parse_turns(code.substring(2))
      [t1, t2] = {'-2': ['Z', '2'], '-1':["'", ''], 1:['', "'"], 2: ['2', 'Z']}[turns]
      moves = switch code[0]
        when 'R' then [new Move("R"+t1), new Move("M"+t2)]
        when 'L' then [new Move("L"+t1), new Move("M"+t1)]
        when 'U' then [new Move("U"+t1), new Move("E"+t2)]
        when 'D' then [new Move("D"+t1), new Move("E"+t1)]
        when 'F' then [new Move("F"+t1), new Move("S"+t1)]
        when 'B' then [new Move("B"+t1), new Move("S"+t2)]
      new CompositeMove(moves, code)

    else
      if /[><]/.test(code)
        new Rotation(code)
      else
        new Move(code)

  _update_dom: (time = 'later') ->
    return unless @dom_handler

    if time == 'first time'
      @dom_handler.init_alg_text(this.display_text().future)

    @dom_handler.alg_changed(@playing, this.at_start(), this.at_end(), this._count_text(), this.display_text())

  _count_text: ->
    total = current = 0
    for move, i in @actions
      current += move.count() if @next > i
      total += move.count()
    "#{current}/#{total}"