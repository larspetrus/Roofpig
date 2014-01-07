#= require roofpig/utils
#= require roofpig/CubeExp

class @Colors

  constructor: (colored, solved, tweaks, colors_settings = "") ->
    @colored = new CubeExp(colored || "*")
    @solved = new CubeExp(solved)
    @tweaks = new CubeExp(tweaks)
    @side_colors = Colors._set_colors(colors_settings)

  to_draw: (piece_name, side) ->
    result = { hovers: false, color: this.of(side) }

    if @solved.matches_sticker(piece_name, side)
      result.color = this.of('solved')
    else if @colored.matches_sticker(piece_name, side)
      result.hovers = true
    else
      result.color = this.of('ignored')

    for tweak in (@tweaks.for_sticker(piece_name, side) || "").split('')
      switch tweak
        when 'X', 'x'
          result.hovers = true
          result.x_color = if tweak == 'X' then 'black' else 'white'
        else
          if Side.by_name(tweak)
            result.hovers = true
            result.color = this.of(tweak)
          else
            log_error("Unknown tweak: '#{tweak}'")
    result

  of: (sticker_type) ->
    type = sticker_type.name || sticker_type
    unless @side_colors[type]
      throw new Error("Unknown sticker type '#{sticker_type}'")
    @side_colors[type]

  DEFAULT_COLORS = {G:'#0d0', B:'blue', R:'red', O:'orange', Y:'yellow', W:'#eee'}
  @_set_colors: (colors_settings) ->
    dc = DEFAULT_COLORS
    result = {R:dc.G, L:dc.B, F:dc.R, B:dc.O, U:dc.Y, D:dc.W, solved:'#444', ignored:'#888', plastic:'black'}

    for setting in colors_settings.split(' ')
      [type, color] = setting.split(':')
      type = {s:'solved', i:'ignored', p:'plastic'}[type] || type
      result[type] = DEFAULT_COLORS[color] || color
    result
