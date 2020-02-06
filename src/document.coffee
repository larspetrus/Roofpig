#= require Css

$(document).ready ->
  console.log("Roofpig version 1.4. ♇ (@@BUILT_WHEN@@). Expecting jQuery 3.1.1 and Three.js 71.")
  console.log("jQuery version", $.fn.jquery)

  # alex
  # suppress insertion of stylesheet if host page already has a stylesheet with attribute title=roofpig
  # otherwise, no way to override because the stylesheet is appended at document.ready and has highest precedence
  configNoCSS = false;
  for styleSheet in document.styleSheets
    if styleSheet.title == 'roofpig'
      configNoCSS = true;
  if configNoCSS
    console.log("Stylesheet with title roofpig present. Injection of roofpig CSS has been suppressed.");

  $('head').append(Css.CODE) unless configNoCSS

  CubeAnimation.initialize()

  pigs = $('.roofpig')
  console.log("Found #{pigs.length} .roofpig divs")
  for roofpig_div in pigs
    new CubeAnimation($(roofpig_div))
