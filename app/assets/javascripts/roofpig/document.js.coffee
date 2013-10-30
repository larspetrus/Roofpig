$(document).ready ->
  roofpig_divs = $('.roofpig')
  displays = {}

  for rpd in roofpig_divs
    display = new Display($(rpd))
    displays[display.id] = display
    display.animate()

  jQuery("button").click ->
    display = displays[jQuery(this).data('dpid')]
    display.button_click(jQuery(this).attr("id"))
