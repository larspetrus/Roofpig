#= require roofpig/Move
#= require roofpig/CompositeMove
#= require roofpig/changers/AlgAnimation

class @Alg
  constructor: (@move_codes, @world3d, @algdisplay, @speed, @dom) ->
    if not @move_codes || @move_codes == ""
      throw new Error("Invalid alg: '#{@move_codes}'")
    this._pre_process()

    @moves = []
    for code in @move_codes.split(' ')
      if code.length > 0
        @moves.push(this._make_move(code))
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

  premix: ->
    @next =  @moves.length
    until this.at_start()
      this.prev_move().premix()
    this

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

  turn_codes = {'-2': ['Z', '2'], '-1': ["'", ''], 1: ['', "'"], 2: ['2', 'Z']}
  _make_move: (code) ->
    if code.indexOf('+') > -1
      new CompositeMove(code, @world3d, @speed)

    else if code[0] in ['x', 'y', 'z']
      [t1, t2] = turn_codes[Move.parse_turns(code.substring(1))]
      moves = switch code[0]
        when 'x' then "R#{t1}+M#{t2}+L#{t2}"
        when 'y' then "U#{t1}+E#{t2}+D#{t2}"
        when 'z' then "F#{t1}+S#{t1}+B#{t2}"
      new CompositeMove(moves, @world3d, @speed, code)

    else if code[1] == 'w' && code[0] in ['U', 'D', 'L', 'R', 'F', 'B']
      [t1, t2] = turn_codes[Move.parse_turns(code.substring(2))]
      moves = switch code[0]
        when 'R' then "R#{t1}+M#{t2}"
        when 'L' then "L#{t1}+M#{t1}"
        when 'U' then "U#{t1}+E#{t2}"
        when 'D' then "D#{t1}+E#{t1}"
        when 'F' then "F#{t1}+S#{t1}"
        when 'B' then "B#{t1}+S#{t2}"
      new CompositeMove(moves, @world3d, @speed, code)

    else
      new Move(code, @world3d, @speed)

  _update_dom: (time = 'later') ->
    return unless @dom

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