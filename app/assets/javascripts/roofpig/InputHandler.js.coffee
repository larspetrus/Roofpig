#= require roofpig/utils

#This is all global data and functions. Think of it as a "singleton" class.
class @InputHandler


  @set_active_display: (new_active) ->
    @dom_handler.has_focus(false) if @active_display

    @active_display = new_active
    @camera = @active_display.camera
    @dom_handler = @active_display.dom_handler

    @dom_handler.has_focus(true)

  @key_down: (e) ->
    [key, shift, ctrl] = [e.keyCode, e.shiftKey, e.ctrlKey]

    if key == key_tab
      new_focus = if shift then @active_display.previous_display() else @active_display.next_display()
      this.set_active_display(new_focus)

    else if key == key_up_arrow
      @active_display.to_end()

    else if key in button_keys
      this._fake_click_down(this._button_for(key, shift))

    else if key in rotate_keys
      axis = switch key
        when key_C, key_Z then 'up'
        when key_A, key_D then 'dr'
        when key_S, key_X then 'dl'
      turns = switch key
        when key_C, key_A, key_S then 1
        when key_Z, key_D, key_X then -1
      this._rotate(axis, turns)

    else if key in turn_keys
      turns = if shift then 3 else if ctrl then 2 else 1
      this._move("#{turn_for[key]}#{turns}")

    else
      return false

  @_button_for: (key, shift) ->
    switch key
      when key_home, key_down_arrow
        @dom_handler.reset
      when key_left_arrow
        if shift then @dom_handler.reset else @dom_handler.prev
      when key_right_arrow
        if shift then @dom_handler.active_play_or_pause else @dom_handler.next
      when key_space
        @dom_handler.active_play_or_pause

  @key_up: (e) ->
    button_key = e.keyCode in button_keys
    if button_key
      if @down_button
        this._fake_click_up(@down_button)
        @down_button = null
    return button_key

  @_fake_click_down: (button) ->
    unless button.attr("disabled")
      @down_button = button
      button.addClass('roofpig-button-fake-active')

  @_fake_click_up: (button) ->
    unless button.attr("disabled")
      button.removeClass('roofpig-button-fake-active')
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
  key_up_arrow = 38
  key_right_arrow = 39
  key_down_arrow = 40
  key_A = 65
  key_C = 67
  key_D = 68
  key_J = 74
  key_K = 75
  key_L = 76
  key_S = 83
  key_X = 88
  key_Z = 90

  button_keys = [key_tab, key_space, key_home, key_left_arrow, key_right_arrow, key_down_arrow]
  rotate_keys = [key_C, key_Z, key_A, key_D, key_S, key_X]
  turn_keys   = [key_J, key_K, key_L]

  turn_for = {}
  turn_for[key_J] = "U"
  turn_for[key_K] = "F"
  turn_for[key_L] = "R"
