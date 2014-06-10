#= require roofpig/utils
#= require roofpig/Layer
#= require roofpig/Cubexp

class @Tweaks

  constructor: (expressions) ->
    @tweaks = {}
    return unless expressions

    for expression in expressions.split(" ")
      [tweak_codes, sides] = expression.split(':')
      continue unless sides

      if tweak_codes.length == 1
        for piece_exp in new Cubexp(sides).selected_pieces()
          for side in piece_exp.split('')
            this._add(piece_exp.toUpperCase(), side, tweak_codes)
      else
        piece = standardize_name(sides.toUpperCase())
        for side, i in sides.split('')
          this._add(piece, side, tweak_codes[i])


  for_sticker: (piece, side) ->
    match = @tweaks[standardize_name(piece)] || {}
    match[side_name(side)] || []

  _add: (piece, side, code) ->
    if Layer.side_by_name(side) # not lower case
      @tweaks[piece] ?= {}
      @tweaks[piece][side] ?= []
      @tweaks[piece][side].push(code)
