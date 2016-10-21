#= require utils
#= require Cubexp
#= require Tweaks

class Colors

  constructor: (side_drift, colored, solved, tweaks, colors = "") ->
    @colored = new Cubexp(this._undrift(colored, side_drift) || "*")
    @solved = new Cubexp(this._undrift(solved, side_drift))
    @tweaks = new Tweaks(this._undrift(tweaks, side_drift))
    @side_colors = Colors._set_colors(colors, side_drift)

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

  _undrift: (code, side_drift) ->
    return code unless code

    reverse_drift = {}
    for own key, value of side_drift
      reverse_drift[value] = key
      reverse_drift[value.toLowerCase()] = key.toLowerCase()

    (reverse_drift[char] || char for char in code.split('')).join('')

  DEFAULT_COLORS = {g:'#0d0', b:'#07f', r:'red', o:'orange', y:'yellow', w:'#eee'}
  @_set_colors: (overrides, side_drift) ->
    dc = DEFAULT_COLORS
    result = {R:dc.g, L:dc.b, F:dc.r, B:dc.o, U:dc.y, D:dc.w, solved:'#444', ignored:'#888', cube:'black'}

    for override in overrides.split(' ')
      [type, color] = override.split(':')
      type = {s:'solved', i:'ignored', c:'cube'}[type] || type
      result[type] = DEFAULT_COLORS[color] || color

    [r, d] = [result, side_drift]
    [r.U, r.D, r.R, r.L, r.F, r.B] = [r[d.U], r[d.D], r[d.R], r[d.L], r[d.F], r[d.B]]
    result
