$(document).ready ->
  for roofpig_div in $('.roofpig')
    new Display($(roofpig_div)).animate()

  $('.roofpig').click ->
    display = Display.instances[$(this).data('dpid')]
    InputHandler.set_active_display(display)

  $("button").click ->
    display = Display.instances[$(this).data('dpid')]
    display.button_click($(this).attr("id"))

  $("body").keydown (e) ->
    InputHandler.key_pressed(e)

  $(".roofpig").mousedown (e) ->
    InputHandler.mouse_down(e, $(this).data('dpid'))

  $("body").mouseup (e) ->
    InputHandler.mouse_end(e)

  $("body").mouseleave (e) ->
    InputHandler.mouse_end(e)

  $("body").mousemove (e) ->
    InputHandler.mouse_move(e)
