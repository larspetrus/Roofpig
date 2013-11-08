#= require roofpig/Settings

class @Settings
  constructor: (settings_dom) ->
    @alg = settings_dom.data("alg")
    @hover = settings_dom.data("hover") || 6.5
    @solve_to = settings_dom.data("solveto") || 'full' # 'full', 'FL'
    @flags = settings_dom.data("flags") || ""

  flag: (name) ->
    @flags.indexOf(name) > -1