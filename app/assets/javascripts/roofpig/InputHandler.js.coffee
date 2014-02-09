#= require roofpig/utils

class @InputHandler

  @set_active_display: (new_active) ->
    @dom_handler.has_focus(false) if @active_display

    @active_display = new_active
    @camera = @active_display.camera
    @dom_handler = @active_display.dom_handler

    @dom_handler.has_focus(true)

  @key_down: (e) ->
    if e.shiftKey
      turns = 3
    else
      turns = if e.ctrlKey then 2 else 1

    unhandled = false

    switch e.keyCode
      when key_tab
        new_focus = if e.shiftKey then @active_display.previous_display() else @active_display.next_display()
        this.set_active_display(new_focus)
      when key_home        then @dom_handler.reset.css('background-color': '#bbb')
      when key_left_arrow  then @dom_handler.prev.css('background-color': '#bbb')
      when key_right_arrow then @dom_handler.next.css('background-color': '#bbb')
      when key_space       then @dom_handler.active_play_or_pause.css('background-color': '#bbb')
      when key_C then this._rotate('up', 1)
      when key_Z then this._rotate('up',-1)
      when key_A then this._rotate('dr', 1)
      when key_D then this._rotate('dr',-1)
      when key_S then this._rotate('dl', 1)
      when key_X then this._rotate('dl',-1)
      when key_J then this._move("U#{turns}")
      when key_K then this._move("F#{turns}")
      when key_L then this._move("R#{turns}")
      else
        unhandled = true

    unhandled

  @key_up: (e) ->
    unhandled = false

    switch e.keyCode
      when key_home        then this._click(@dom_handler.reset)
      when key_left_arrow  then this._click(@dom_handler.prev)
      when key_right_arrow then this._click(@dom_handler.next)
      when key_space       then this._click(@dom_handler.active_play_or_pause)
      else
        unhandled = true

    unhandled

  @_click: (button) ->
    button.css('background-color': '')
    button.click()

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
      if e.shiftKey
        dy = 0
      @camera.bend(dx, dy)
      @active_display.force_render()

  @_rotate: (axis_name, turns) ->
    angle_to_turn = -Math.PI/2 * turns
    @active_display.add_changer('spin', new CameraMovement(@camera, @camera.user_dir[axis_name], angle_to_turn, 500, true))

  @_move: (side, turns) ->
    @active_display.add_changer('move', new Move(side, turns).show_do(@active_display.world3d))


  # http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes
  key_tab = 9
  key_space = 32
  key_home = 36
  key_left_arrow = 37
  key_right_arrow = 39
  key_A = 65
  key_C = 67
  key_D = 68
  key_J = 74
  key_K = 75
  key_L = 76
  key_S = 83
  key_X = 88
  key_Z = 90
