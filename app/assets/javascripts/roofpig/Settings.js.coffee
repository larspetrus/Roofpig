class @Settings
  constructor: (settings_dom) ->
    @alg = settings_dom.data("alg") ||""
    @hover = settings_dom.data("hover") || 6.5
    @color_only = Settings._expand_sticker_exp(settings_dom.data("coloronly"))
    @flags = settings_dom.data("flags") || ""

  flag: (name) ->
    @flags.indexOf(name) > -1

  PIECE_NAMES = ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']
  @_expand_sticker_exp: (expressions) ->
    return " #{PIECE_NAMES.join(' ')} " unless expressions

    result = " "
    for exp in expressions.split(" ")
      if exp.charAt(exp.length - 1) == "*"
        if exp.length == 4
          c1 = exp.charAt(0)
          c2 = exp.charAt(1)
          c3 = exp.charAt(2)
          result += c1+c2+c3+" "+c1+c2+" "+c1+c3+" "+c2+c3+" "+c1+" "+c2+" "+c3+" "
        if exp.length == 2
          for name in PIECE_NAMES
            if name.indexOf(exp.charAt(0)) > -1
              result += name + " "
      else
        result += exp + " "
    result