#= require Css

$(document).ready ->
  console.log("Roofpig version 1.4. ♇ (@@BUILT_WHEN@@). Expecting jQuery 3.1.1 and Three.js 71.")
  console.log("jQuery version", $.fn.jquery)

  $('head').append(Css.CODE)

  CubeAnimation.initialize()

  pigs = $('.roofpig')
  console.log("Found #{pigs.length} .roofpig divs")
  for roofpig_div in pigs
    new CubeAnimation($(roofpig_div))
