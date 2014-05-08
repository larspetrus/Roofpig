$(document).ready ->
  console.log("jQuery version", $.fn.jquery)

  webgl_browser = (->
    try
      return !!window.WebGLRenderingContext and !!document.createElement("canvas").getContext("experimental-webgl")
    catch e
      return false
  )()

  canvas_browser = !!window.CanvasRenderingContext2D
  if canvas_browser
    log_error("No WebGL support in this browser. Falling back on regular Canvas.") unless webgl_browser
  else
    log_error("No Canvas support in this browser. Giving up.")


  for roofpig_div in $('.roofpig')
    new Display($(roofpig_div), webgl_browser, canvas_browser).animate()

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
