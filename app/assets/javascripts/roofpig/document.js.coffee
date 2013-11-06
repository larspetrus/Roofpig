$(document).ready ->
  for rpd in $('.roofpig')
    new Display($(rpd)).animate()

  jQuery("button").click ->
    display = Display.instances[jQuery(this).data('dpid')]
    display.button_click(jQuery(this).attr("id"))
