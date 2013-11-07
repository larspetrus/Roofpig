$(document).ready ->
  for roofpig_div in $('.roofpig')
    new Display($(roofpig_div)).animate()

  $('.roofpig').click ->
    display = Display.instances[$(this).data('dpid')]
    InputHandler.set_active_display(display)

  $("button").click ->
    display = Display.instances[$(this).data('dpid')]
    display.button_click($(this).attr("id"))

  $("body").keydown (e) =>
    InputHandler.key_pressed(e)
