$(document).ready ->
  canvas_works = !!window.CanvasRenderingContext2D

  webgl_works = (->
    try
      return !!window.WebGLRenderingContext and !!document.createElement("canvas").getContext("experimental-webgl")
    catch e
      return false
  )()

  if canvas_works
    log_error("No WebGL support in this browser. Falling back on regular Canvas.") unless webgl_works
  else
    log_error("No Canvas support in this browser. Giving up.")


  for roofpig_div in $('.roofpig')
    new Display($(roofpig_div), webgl_works, canvas_works).animate()

  $('.roofpig').click ->
    display = Display.instances[$(this).data('dpid')]
    InputHandler.set_active_display(display)

  $("button").click (e) ->
    display = Display.instances[$(this).data('dpid')]
    display.button_click($(this).attr("id"), e.shiftKey)

  $("body").keydown (e) ->
    InputHandler.key_down(e)

  $("body").keyup (e) ->
    InputHandler.key_up(e)

  $(".roofpig").mousedown (e) ->
    InputHandler.mouse_down(e, $(this).data('dpid'))

  $("body").mouseup (e) ->
    InputHandler.mouse_end(e)

  $("body").mouseleave (e) ->
    InputHandler.mouse_end(e)

  $("body").mousemove (e) ->
    InputHandler.mouse_move(e)
