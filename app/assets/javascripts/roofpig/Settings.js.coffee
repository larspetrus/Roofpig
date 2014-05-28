#= require roofpig/Colors

class @Settings
  constructor: (@settings_dom, @prefs) ->
    if typeof @prefs == 'string'
      @prefs = Settings._parse(@prefs)

    @prefs ||= {}

    @alg    = this._get("alg")
    @hover  = this._get("hover", 2.0)
    @flags  = (this._get("flags") + ' ' + this._get("moreflags")).trim()
    @colors = new Colors(this._get("colored"), this._get("solved"), this._get("tweaks"), this._get("colors"))
    @setup  = this._get("setup")
    @pov    = this._get("pov", "Ufr")

  @from_page: (settings_dom) ->
    prefs = window["ROOFPIG_PREF_" + settings_dom.data("pref")]
    new Settings(settings_dom, prefs)

  flag: (name) ->
    @flags.indexOf(name) > -1

  _get: (name, default_value = "") ->
    @settings_dom.data(name) || @prefs[name] || default_value

  @_parse: (settings_string) ->
    result = {}
    for segment in settings_string.split("|")
      eq_pos = segment.indexOf("=")
      key = segment.substring(0, eq_pos).trim()
      value = segment.substring(eq_pos+1).trim()
      result[key] = value
    result