#= require roofpig/Settings

class @Settings
  constructor: (settings_dom) ->
    @alg = settings_dom.data("alg")
    @hover = settings_dom.data("hover") || 6.5
