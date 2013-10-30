class @InputHandler

  constructor: (@display) ->
    $("body").keydown (e) =>
      this.key_pressed(e)

  key_pressed: (e) ->
    key = String.fromCharCode(e.keyCode)
    if key in ['U', 'D', 'F', 'B', 'L', 'R']
      if e.shiftKey
        turns = 3
      else
        turns = if e.ctrlKey then 2 else 1

      @display.new_single_move(new Move(Side.by_name(key), turns).do(@display.pieces3d))
