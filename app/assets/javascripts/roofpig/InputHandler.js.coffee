#= require roofpig/v3_utils

class @InputHandler

  @set_active_display: (new_active) ->
    @dom_handler.has_focus(false) if @active_display

    @active_display = new_active
    @camera = @active_display.camera
    @dom_handler = @active_display.dom_handler

    @dom_handler.has_focus(true)

  @key_pressed: (e) ->
    if e.shiftKey
      turns = 3
    else
      turns = if e.ctrlKey then 2 else 1

    switch String.fromCharCode(e.keyCode)
      when ' ' then @dom_handler.play_or_pause.click()
      when 'C' then this._rotate('z', 1)
      when 'Z' then this._rotate('z', 3)
      when 'X' then this._rotate('y', 1)
      when 'D' then this._rotate('y', 3)
      when 'A' then this._rotate('x', 1)
      when 'S' then this._rotate('x', 3)
      when 'J' then this._move("U#{turns}")
      when 'K' then this._move("F#{turns}")
      when 'L' then this._move("R#{turns}")

  @mouse_down: (e, target_display_id) ->
    if target_display_id == @active_display.id
      @bend_start_x = e.pageX
      @bend_start_y = e.pageY

      @bending = true

  @mouse_end: (e) ->
    @camera.bend(0, 0)
    @active_display.force_render()
    @bending = false

  @mouse_move: (e) ->
    if @bending
      dx = -0.02 * (e.pageX - @bend_start_x) / @dom_handler.scale
      dy = -0.02 * (e.pageY - @bend_start_y) / @dom_handler.scale
      @camera.bend(dx, dy)
      @active_display.force_render()

  @_rotate: (axis_name, turns) ->
    q_turn = -Math.PI/2
    angle_to_turn = [q_turn, 2*q_turn, -q_turn][turns-1]
    @active_display.add_changer('spin', new CameraAnimation(@camera, @camera.user_dir[axis_name], angle_to_turn, 600))

  @_move: (side, turns) ->
    @active_display.add_changer('move', new Move(side, turns).do(@active_display.pieces3d))