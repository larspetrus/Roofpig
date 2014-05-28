#= require roofpig/Colors

class @Config
  constructor: (@config_dom, @prefs) ->
    if typeof @prefs == 'string'
      @prefs = Config._parse(@prefs)

    @prefs ||= {}

    @alg    = this._get("alg")
    @hover  = this._get("hover", 2.0)
    @flags  = (this._get("flags") + ' ' + this._get("moreflags")).trim()
    @colors = new Colors(this._get("colored"), this._get("solved"), this._get("tweaks"), this._get("colors"))
    @setup  = this._get("setup")
    @pov    = this._get("pov", "Ufr")

  @from_page: (config_dom) ->
    prefs = window["ROOFPIG_PREF_" + config_dom.data("pref")]
    new Config(config_dom, prefs)

  flag: (name) ->
    @flags.indexOf(name) > -1

  _get: (name, default_value = "") ->
    @config_dom.data(name) || @prefs[name] || default_value

  @_parse: (config_string) ->
    result = {}
    for conf in config_string.split("|")
      eq_pos = conf.indexOf("=")
      key = conf.substring(0, eq_pos).trim()
      value = conf.substring(eq_pos+1).trim()
      result[key] = value
    result