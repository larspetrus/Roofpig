#= require roofpig/Css

$(document).ready ->
  console.log("Roofpig version 1.0 (@@BUILT_WHEN@@). Expecting jQuery 1.11.1 and Three.js 67.")
  console.log("jQuery version", $.fn.jquery)

  $('head').append(Css.CODE)

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
    new CubeAnimation($(roofpig_div), webgl_browser, canvas_browser)

  EventHandlers.initialize()