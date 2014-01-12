#= require roofpig/utils
#= require roofpig/Side

class @Tweaks

  constructor: (expressions = "") ->
    @tweaks = {}

    for expression in expressions.split(" ")
      [sides, codes] = expression.split(':')
      piece = standardize_name(sides.toUpperCase())

      for side, i in sides.split('')
        if Side.by_name(side)
          for_piece = @tweaks[piece] ?= {}
          for_piece[side] ?= []
          for_piece[side].push(codes[i])

  for_sticker: (piece, side) ->
    match = @tweaks[standardize_name(piece)] || {}
    match[side_name(side)] || []
