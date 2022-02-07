#= require utils
#= require OneChange

#This is all page wide data and functions.
class EventHandlers
  @initialized = false

  @set_focus: (new_focus) ->
    if @_focus != new_focus
      @dom.has_focus(false) if @_focus

      @_focus = new_focus
      unless @focus().is_null
        @camera = @_focus.world3d.camera
        @dom = @_focus.dom

        @dom.has_focus(true)

  NO_FOCUS = {
    add_changer: -> {}
    is_null: true
  }
  @focus: ->
    @_focus || NO_FOCUS

  @initialize: ->
    return if @initialized

    $('body').keydown (e) -> EventHandlers.key_down(e)
    $('body').keyup   (e) -> EventHandlers.key_up(e)

    $(document).on('mousedown', '.roofpig', (e) -> EventHandlers.mouse_down(e, $(this).data('cube-id')))
    $('body').mousemove  (e) -> EventHandlers.mouse_move(e)
    $('body').mouseup    (e) -> EventHandlers.mouse_end(e)
    $('body').mouseleave (e) -> EventHandlers.mouse_end(e)

    $(document).on('click', '.roofpig', (e) ->
      cube = CubeAnimation.by_id[$(this).data('cube-id')]
      EventHandlers.set_focus(cube))

    $(document).on('click', '.roofpig button', (e) ->
      [button_name, cube_id] = $(this).attr('id').split('-')
      CubeAnimation.by_id[cube_id].button_click(button_name, e.shiftKey))

    $(document).on('click', '.roofpig-help-button', (e) ->
      [_, cube_id] = $(this).attr('id').split('-')
      CubeAnimation.by_id[cube_id].dom.show_help())

    @initialized = true

  @mouse_down: (e, clicked_cube_id) ->
    @dom.remove_help()
    
    if clicked_cube_id == @focus().id
      @bend_start_x = e.pageX
      @bend_start_y = e.pageY

      @bending = true

  @mouse_end: (e) ->
    @focus().add_changer('camera', new OneChange( => @camera.bend(0, 0)))
    @bending = false

  @mouse_move: (e) ->
    if @bending
      dx = -0.02 * (e.pageX - @bend_start_x) / @dom.scale
      dy = -0.02 * (e.pageY - @bend_start_y) / @dom.scale
      if e.shiftKey
        dy = 0
      @focus().add_changer('camera', new OneChange( => @camera.bend(dx, dy)))


  # ---- Keyboard Events ----

  @key_down: (e) ->
    return if @focus().is_null

    help_toggled = @dom.remove_help()

    if e.ctrlKey || e.metaKey
      return true

    [key, shift, alt] = [e.keyCode, e.shiftKey, e.altKey]

    if key in turn_keys
      turns = if shift then 3 else if alt then 2 else 1
      side_for = {}
      side_for[turn_B] = "B"
      side_for[turn_D] = "D"
      side_for[turn_F] = "F"
      side_for[turn_L] = "L"
      side_for[turn_R] = "R"
      side_for[turn_U] = "U"
      this._move("#{side_for[key]}#{turns}")

    else if alt
      unhandled = true

    else if key == key_tab
      new_focus = if shift then @focus().previous_cube() else @focus().next_cube()
      this.set_focus(new_focus)

    else if key == key_end || (key == menu_next && shift)
      @focus().add_changer('pieces', new OneChange( => @focus().alg.to_end(@focus().world3d)))

    else if key in button_keys
      this._fake_click_down(this._button_for(key, shift))

    else if key in rotate_keys
      axis = switch key
        when rotate_D, rotate_U then 'up'
        when rotate_L, rotate_R then 'dr'
        when rotate_B, rotate_F then 'dl'
      turns = switch key
        when rotate_D, rotate_L, rotate_B then 1
        when rotate_U, rotate_R, rotate_F then -1
      this._rotate(axis, turns)

    else if key == key_question
      @focus().dom.show_help() unless help_toggled

    else
      unhandled = true

    unless unhandled
      e.preventDefault()
      e.stopPropagation()


  @_button_for: (key, shift) ->
    switch key
      when menu_reset
        @dom.reset
      when menu_prev
        unless shift then @dom.prev else @dom.reset
      when menu_next
       @dom.next
      when menu_play
        @dom.play_or_pause

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

  @_rotate: (axis_name, turns) ->
    angle_to_turn = -Math.PI/2 * turns
    @focus().add_changer('camera', new CameraMovement(@camera, @camera.user_dir[axis_name], angle_to_turn, 500, true))

  @_move: (code) ->
    @focus().add_changer('pieces', new Move(code, @focus().world3d, 200).show_do())


  # Declare keycodes for physical keys
  # (http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes)
  key_tab = 9
  key_space = 32
  key_end = 35
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

  numpad_0 = 96
  numpad_1 = 97
  numpad_2 = 98
  numpad_3 = 99
  numpad_4 = 100
  numpad_5 = 101
  numpad_6 = 102
  numpad_7 = 103
  numpad_8 = 104
  numpad_9 = 105
  
  key_question = 191


  # Map physical keys to logical actions
  # TODO: extract into a config option

  # cube rotations
  rotate_B = key_S
  rotate_D = key_C
  rotate_F = key_X
  rotate_L = key_A
  rotate_R = key_D
  rotate_U = key_Z

  # face turns
  turn_B = null
  turn_D = null
  turn_F = key_K
  turn_L = null
  turn_R = key_L
  turn_U = key_J

  # menu buttons
  menu_reset = key_home
  menu_prev = key_left_arrow
  menu_next = key_right_arrow
  menu_play = key_space


  # keybindings will be deactivated automatically, if you assign `null` to them in the mapping above
  compact = (array) ->
    item for item in array when item != null

  button_keys = compact([menu_reset, menu_prev, menu_next, menu_play])
  rotate_keys = compact([rotate_B, rotate_D, rotate_F, rotate_L, rotate_R, rotate_U])
  turn_keys   = compact([turn_B, turn_D, turn_F, turn_L, turn_R, turn_U])
