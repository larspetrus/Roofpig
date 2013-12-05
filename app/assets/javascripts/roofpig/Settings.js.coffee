#= require roofpig/Colors

class @Settings
  constructor: (settings_dom) ->
    @alg = settings_dom.data("alg") ||""
    @hover = settings_dom.data("hover") || 6.5
    @flags = settings_dom.data("flags") || ""
    @colors = new Colors(settings_dom.data("colored"), settings_dom.data("solved"))

  flag: (name) ->
    @flags.indexOf(name) > -1