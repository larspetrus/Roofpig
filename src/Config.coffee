#= require Alg
#= require Colors

class Config
  constructor: (config_string) ->
    @raw_input = Config._parse(config_string)
    @base = this.base_config(@raw_input[BASE], config_string)

    @alg = this.raw(ALG)
    @algdisplay= this._alg_display()
    @colors = new Colors(Alg.pov_from(@alg), this.raw(COLORED), this.raw(SOLVED), this.raw(TWEAKS), this.raw(COLORS))
    @flags = this.raw(FLAGS)
    @hover = this._hover()
    @pov = this.raw(POV, "Ufr")
    @setup = this.raw(SETUPMOVES)
    @speed = this.raw(SPEED, 400)

  flag: (name) ->
    @flags.indexOf(name) > -1

  raw: (name, default_value = "") ->
    @raw_input[name] || @base.raw(name) || default_value

  base_config: (base_id, config_string) ->
    base_string = window["ROOFPIG_CONF_#{base_id}"]
    if base_id && not base_string
      log_error("'ROOFPIG_CONF_#{base_id}' does not exist")

    if config_string && config_string == base_string
      log_error("#{base_string} tries to inherit from itself.")
      base_string = null

    if base_string then new Config(base_string) else { raw: -> }

  _hover: ->
    raw_hover = this.raw(HOVER, "near")
    switch raw_hover
      when 'none' then 1.0
      when 'near' then 2.0
      when 'far' then 7.1
      else
        raw_hover

  _alg_display: ->
    ad = this.raw(ALGDISPLAY)
    result = {}
    result.fancy2s = ad.indexOf('fancy2s') > -1
    result.rotations = ad.indexOf('rotations') > -1
    result.Zcode = "2"
    result.Zcode = "2'" if ad.indexOf('2p') > -1
    result.Zcode = "Z"  if ad.indexOf('Z') > -1
    result

  @_parse: (config_string) ->
    return {} unless config_string

    result = {}
    for conf in config_string.split("|")
      eq_pos = conf.indexOf("=")
      key = conf.substring(0, eq_pos).trim()
      value = conf.substring(eq_pos+1).trim()
      result[key] = value

      if PROPERTIES.indexOf(key) == -1
        log_error("Unknown config parameter '#{key}' ignored")

    result

PROPERTIES = [
  ALG = 'alg', BASE = 'base', ALGDISPLAY = 'algdisplay', COLORED = 'colored', COLORS = "colors", FLAGS = 'flags',
  HOVER = 'hover', POV = 'pov', SETUPMOVES = 'setupmoves', SOLVED = 'solved', SPEED = 'speed', TWEAKS = 'tweaks'
]
