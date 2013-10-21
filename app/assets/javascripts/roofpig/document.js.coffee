$(document).ready ->
  display = new Display()
  display.animate()

  jQuery("button").click ->
    display.button_click(jQuery(this).attr("id"))

animate: ->
  display.animate()
