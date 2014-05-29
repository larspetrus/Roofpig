#= require roofpig/Colors

class @Config
  constructor: (config_string) ->
    @config   = Config._parse(config_string)

    base_string = window["ROOFPIG_CONF_" + @config['base']]
    if @config['base'] && not base_string
      log_error("'ROOFPIG_CONF_#{@config['base']}' does not exist")
    @base = Config._parse(base_string)

    @alg    = this._get("alg")
    @hover  = this._get("hover", 2.0)
    @flags  = (this._get("flags") + ' ' + this._get("moreflags")).trim()
    @colors = new Colors(this._get("colored"), this._get("solved"), this._get("tweaks"), this._get("colors"))
    @setup  = this._get("setup")
    @pov    = this._get("pov", "Ufr")

  flag: (name) ->
    @flags.indexOf(name) > -1

  _get: (name, default_value = "") ->
    @config[name] || @base[name] || default_value

  @_parse: (config_string) ->
    return {} unless config_string

    result = {}
    for conf in config_string.split("|")
      eq_pos = conf.indexOf("=")
      key = conf.substring(0, eq_pos).trim()
      value = conf.substring(eq_pos+1).trim()
      result[key] = value
    result