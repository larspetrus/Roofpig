class @InputHandler

  @set_active_display: (new_active) ->
    @active_display.keyboard_focus(false) if @active_display
    new_active.keyboard_focus(true)

    @active_display = new_active

  @key_pressed: (e) ->
    if e.shiftKey
      turns = 3
    else
      turns = if e.ctrlKey then 2 else 1

    switch String.fromCharCode(e.keyCode)
      when ' ' then @active_display.dom_handler.play_or_pause.click()
      when 'C' then this._rotate('z', 1)
      when 'Z' then this._rotate('z', 3)
      when 'X' then this._rotate('y', 1)
      when 'D' then this._rotate('y', 3)
      when 'A' then this._rotate('x', 1)
      when 'S' then this._rotate('x', 3)
      when 'J' then this._move(Side.U, turns)
      when 'K' then this._move(Side.F, turns)
      when 'L' then this._move(Side.R, turns)

  @_rotate: (axis_name, turns) ->
    axis = @active_display.camera.viewer_dir[axis_name]
    q_turn = -Math.PI/2
    total_angle_change = [q_turn, 2*q_turn, -q_turn][turns-1]
    @active_display.add_changer('spin', new CameraAnimation(@active_display.camera, axis, total_angle_change, 600))

  @_move: (side, turns) ->
    @active_display.add_changer('move', new Move(side, turns).do(@active_display.pieces3d))