#= require roofpig/utils
#= require roofpig/CubeExp

class @Colors

  constructor: (colored, solved, colors_settings = "") ->
    @colored = new CubeExp(colored || "*")
    @solved = new CubeExp(solved)
    @side_colors = Colors._set_colors(colors_settings)

  to_draw: (piece_name, side) ->
    if @solved.matches_sticker(piece_name, side)
      { real: false, color: this.of('solved') }
    else if @colored.matches_sticker(piece_name, side)
      { real: true, color: this.of(side) }
    else
      { real: false, color: this.of('ignored') }

  of: (sticker_type) ->
    type = sticker_type.name || sticker_type
    unless @side_colors[type]
      throw new Error("Unknown sticker type '#{sticker_type}'")
    @side_colors[type]

  CODES = {G:'#0d0', B:'blue', R:'red', O:'orange', Y:'yellow', W:'#eee'}
  @_set_colors: (colors_settings) ->
    result = {R:CODES.G, L:CODES.B, F:CODES.R, B:CODES.O, U:CODES.Y, D:CODES.W, solved:'#666', ignored:'#aaa'}

    for setting in colors_settings.split(' ')
      [type, color] = setting.split(':')
      result[type] = CODES[color] || color
    result
