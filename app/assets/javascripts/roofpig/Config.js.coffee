#= require roofpig/Colors

class @Config
  constructor: (@config_dom, baseconf_string = "") ->
    @baseconf = Config._parse(baseconf_string)

    @alg    = this._get("alg")
    @hover  = this._get("hover", 2.0)
    @flags  = (this._get("flags") + ' ' + this._get("moreflags")).trim()
    @colors = new Colors(this._get("colored"), this._get("solved"), this._get("tweaks"), this._get("colors"))
    @setup  = this._get("setup")
    @pov    = this._get("pov", "Ufr")

  @from_page: (config_dom) ->
    baseconf = window["ROOFPIG_CONF_" + config_dom.data("baseconf")]
    new Config(config_dom, baseconf)

  flag: (name) ->
    @flags.indexOf(name) > -1

  _get: (name, default_value = "") ->
    @config_dom.data(name) || @baseconf[name] || default_value

  @_parse: (config_string) ->
    result = {}
    for conf in config_string.split("|")
      eq_pos = conf.indexOf("=")
      key = conf.substring(0, eq_pos).trim()
      value = conf.substring(eq_pos+1).trim()
      result[key] = value
    result