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
      this._move("#{side_for[key]}#{turns}")

    else if alt
      unhandled = true

    else if key == key_tab
      new_focus = if shift then @focus().previous_cube() else @focus().next_cube()
      this.set_focus(new_focus)

    else if key == key_end || (key == key_right_arrow && shift)
      @focus().add_changer('pieces', new OneChange( => @focus().alg.to_end(@focus().world3d)))

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

    else if key == key_question
      @focus().dom.show_help() unless help_toggled

    else
      unhandled = true

    unless unhandled
      e.preventDefault()
      e.stopPropagation()


  @_button_for: (key, shift) ->
    switch key
      when key_home
        @dom.reset
      when key_left_arrow
        unless shift then @dom.prev else @dom.reset
      when key_right_arrow
       @dom.next
      when key_space
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


  # http://www.cambiaresearch.com/articles/15/javascript-char-codes-key-codes
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
  key_question = 191

  button_keys = [key_space, key_home, key_left_arrow, key_right_arrow]
  rotate_keys = [key_C, key_Z, key_A, key_D, key_S, key_X]
  turn_keys   = [key_J, key_K, key_L]

  side_for = {}
  side_for[key_J] = "U"
  side_for[key_K] = "F"
  side_for[key_L] = "R"
