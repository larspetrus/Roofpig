#= require Css

$(document).ready ->
  console.log("Roofpig version 1.3.☂ (@@BUILT_WHEN@@). Expecting jQuery 1.12.4 and Three.js 71.")
  console.log("jQuery version", $.fn.jquery)

  $('head').append(Css.CODE)

  CubeAnimation.initialize()

  pigs = $('.roofpig')
  console.log("Found #{pigs.size()} .roofpig divs")
  for roofpig_div in pigs
    new CubeAnimation($(roofpig_div))
