#= require roofpig/utils
#= require roofpig/WorldChangers

#This is all page wide data and functions.
class @EventHandlers

  @set_focus: (new_focus) ->
    if @focus != new_focus
      @dom_handler.has_focus(false) if @focus

      @focus = new_focus
      @camera = @focus.camera
      @dom_handler = @focus.dom_handler

      @dom_handler.has_focus(true)

  @initialize: () ->
    $("body").keydown (e) -> EventHandlers.key_down(e)
    $("body").keyup (e)   -> EventHandlers.key_up(e)

    $(".roofpig").mousedown (e) -> EventHandlers.mouse_down(e, $(this).data('dpid'))
    $("body").mouseup (e)       -> EventHandlers.mouse_end(e)
    $("body").mouseleave (e)    -> EventHandlers.mouse_end(e)
    $("body").mousemove (e)     -> EventHandlers.mouse_move(e)

    $('.roofpig').click (e) ->
      cube = CubeAnimation.instances[$(this).data('dpid')]
      EventHandlers.set_focus(cube)

    $("button").click (e) ->
      [button_type, cube_id] = $(this).attr("id").split("-")
      cube = CubeAnimation.instances[cube_id]
      cube.button_click(button_type, e.shiftKey)


  # ---- Mouse Events ----

  @mouse_down: (e, target_cube_id) ->
    if target_cube_id == @focus.id
      @bend_start_x = e.pageX
      @bend_start_y = e.pageY

      @bending = true

  @mouse_end: (e) ->
    @focus.add_changer('spin', new OneChange( => @camera.bend(0, 0)))
    @bending = false

  @mouse_move: (e) ->
    if @bending
      dx = -0.02 * (e.pageX - @bend_start_x) / @dom_handler.scale
      dy = -0.02 * (e.pageY - @bend_start_y) / @dom_handler.scale
      if e.shiftKey
        dy = 0
      @focus.add_changer('spin', new OneChange( => @camera.bend(dx, dy)))


  # ---- Keyboard Events ----

  @key_down: (e) ->
    if e.ctrlKey || e.metaKey
      return true

    [key, shift, alt] = [e.keyCode, e.shiftKey, e.altKey]

    if key == key_tab
      new_focus = if shift then @focus.previous_cube() else @focus.next_cube()
      this.set_focus(new_focus)

    else if key == key_end || (key == key_right_arrow && shift)
      @focus.add_changer('move', new OneChange( => @focus.alg.to_end(@focus.world3d)))

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
      turns = if shift then 3 else if alt then 2 else 1
      this._move("#{side_for[key]}#{turns}")

    else
      unhandled = true

    unless unhandled
      e.preventDefault()
      e.stopPropagation()


  @_button_for: (key, shift) ->
    switch key
      when key_home
        @dom_handler.reset
      when key_left_arrow
        unless shift then @dom_handler.prev else @dom_handler.reset
      when key_right_arrow
       @dom_handler.next
      when key_space
        @dom_handler.play_or_pause

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
    @focus.add_changer('spin', new CameraMovement(@camera, @camera.user_dir[axis_name], angle_to_turn, 500, true))

  @_move: (side, turns) ->
    @focus.add_changer('move', new Move(side, turns).show_do(@focus.world3d))


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

  button_keys = [key_space, key_home, key_left_arrow, key_right_arrow]
  rotate_keys = [key_C, key_Z, key_A, key_D, key_S, key_X]
  turn_keys   = [key_J, key_K, key_L]

  side_for = {}
  side_for[key_J] = "U"
  side_for[key_K] = "F"
  side_for[key_L] = "R"
