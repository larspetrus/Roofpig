#= require utils
#= require Cubexp
#= require Tweaks

class Colors

  constructor: (pov, colored, solved, tweaks, overrides = "") ->
    @colored = new Cubexp(pov.cube_to_hand(colored) || "*")
    @solved = new Cubexp(pov.cube_to_hand(solved))
    @tweaks = new Tweaks(pov.cube_to_hand(tweaks))
    @side_colors = Colors._set_colors(overrides, pov.hand_to_cube_map())

  to_draw: (piece_name, side) ->
    result = { hovers: false, color: this.of(side) }

    if @solved.matches_sticker(piece_name, side)
      result.color = this.of('solved')
    else if @colored.matches_sticker(piece_name, side)
      result.hovers = true
    else
      result.color = this.of('ignored')

    for tweak in @tweaks.for_sticker(piece_name, side)
      result.hovers = true
      switch tweak
        when 'X', 'x'
          result.x_color = {X: 'black', x: 'white'}[tweak]
        else
          if Layer.by_name(tweak)
            result.color = this.of(tweak)
          else
            log_error("Unknown tweak: '#{tweak}'")
    result

  of: (sticker_type) ->
    type = sticker_type.name || sticker_type
    unless @side_colors[type]
      throw new Error("Unknown sticker type '#{sticker_type}'")
    @side_colors[type]

  DEFAULT_COLORS = {g:'#0d0', b:'#07f', r:'red', o:'orange', y:'yellow', w:'#eee'}
  @_set_colors: (config_colors, h2c_map) ->
    dc = DEFAULT_COLORS # shorten name for readability
    result = {R:dc.g, L:dc.b, F:dc.r, B:dc.o, U:dc.y, D:dc.w, solved:'#444', ignored:'#888', cube:'black'}

    for override in config_colors.split(' ')
      [type, color] = override.split(':')
      type = {s:'solved', i:'ignored', c:'cube'}[type] || type
      result[type] = DEFAULT_COLORS[color] || color

    r = result # shorten name for readability
    [r.U, r.D, r.R, r.L, r.F, r.B] = [r[h2c_map.U], r[h2c_map.D], r[h2c_map.R], r[h2c_map.L], r[h2c_map.F], r[h2c_map.B]]
    result
