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

    key = String.fromCharCode(e.keyCode)
    if key in ['U', 'D', 'F', 'B', 'L', 'R']
      @active_display.add_changer('move', new Move(Side.by_name(key), turns).do(@active_display.pieces3d))

    if key == '1'
      this._rotate(@active_display.camera.viewer_z, turns)
    if key == '2'
      this._rotate(@active_display.camera.viewer_x, turns)
    if key == '3'
      this._rotate(@active_display.camera.viewer_y, turns)

  @_rotate: (axis, turns) ->
    q_turn = -Math.PI/2
    total_angle_change = [q_turn, 2*q_turn, -q_turn][turns-1]
    @active_display.add_changer('spin', new CameraAnimation(@active_display.camera, axis, total_angle_change, 600))