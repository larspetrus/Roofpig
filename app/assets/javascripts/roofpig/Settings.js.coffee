#= require roofpig/Colors

class @Settings
  constructor: (@settings_dom, @prefs) ->
    @prefs ||= {}

    @alg    = this._get("alg")
    @hover  = this._get("hover", 6.5)
    @flags  = this._get("flags")
    @colors = new Colors(this._get("colored"), this._get("solved"), this._get("colors"))
    @setup  = this._get("setup")

  _get: (name, default_value = "") ->
    @settings_dom.data(name) || @prefs[name] || default_value

  @from_page: (settings_dom) ->
    if settings_dom.data("pref")
      prefs = window["ROOFPIG_PREF_" + settings_dom.data("pref")]
    new Settings(settings_dom, prefs)

  flag: (name) ->
    @flags.indexOf(name) > -1