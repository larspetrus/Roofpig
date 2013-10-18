class @InputHandler
  moves: []

  constructor: ->
    $("body").keydown (e) =>
      this.key_pressed(e)

  key_pressed: (e) ->
    key = String.fromCharCode(e.keyCode)
    if key in ['U', 'D', 'F', 'B', 'L', 'R']
      if e.shiftKey
        turns = 3
      else if e.ctrlKey
        turns = 2
      else
        turns = 1

      @moves.push(new Move(Side.by_name(key), turns))

  next_move: ->
    @moves.shift()
