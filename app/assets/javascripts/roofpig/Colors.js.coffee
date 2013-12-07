#= require roofpig/Side
#= require roofpig/Pieces3D

class @Colors

  constructor: (colored, solved, colors_settings = "") ->
    @colored = Colors._expand(colored)
    @solved = Colors._expand(solved || "n/a")
    @side_colors = Colors._set_colors(colors_settings)


  at: (piece_name, side) ->
    if Colors._selected_sticker(@solved, piece_name)
      { real: false, color: this.of('solved') }
    else if Colors._selected_sticker(@colored, piece_name)
      { real: true, color: this.of(side) }
    else
      { real: false, color: this.of('ignored') }

  of: (sticker_type) ->
    type = sticker_type.name || sticker_type
    unless @side_colors[type]
      throw new Error("Unknown sticker type '#{sticker_type}'")
    @side_colors[type]

  @_selected_sticker: (selection, piece_name) ->
    normalized_name = Pieces3D.piece_name(piece_name[0], piece_name[1], piece_name[2])
    selection.indexOf(" #{normalized_name} ") > -1

  PIECE_NAMES = ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']
  @_expand: (expressions) ->
    return " #{PIECE_NAMES.join(' ')} " unless expressions

    result = " "
    for exp in expressions.split(" ")
      if exp[exp.length - 1] == "*"
        if exp.length == 4
          [c1, c2, c3] = [exp[0], exp[1], exp[2]]
          result += c1+c2+c3+" "+c1+c2+" "+c1+c3+" "+c2+c3+" "+c1+" "+c2+" "+c3+" "
        if exp.length == 2
          for name in PIECE_NAMES
            if name.indexOf(exp[0]) > -1
              result += name + " "
      else
        result += exp + " "
    result

  CODES = {G:'#0d0', B:'blue', R:'red', O:'orange', Y:'yellow', W:'#eee'}
  @_set_colors: (colors_settings) ->
    result = {R:CODES.G, L:CODES.B, F:CODES.R, B:CODES.O, U:CODES.Y, D:CODES.W, solved:'#666', ignored:'#aaa'}

    for setting in colors_settings.split(' ')
      [type, color] = setting.split(':')
      result[type] = CODES[color] || color
    result
