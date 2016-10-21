#= require utils
#= require Layer
#= require Cubexp

class Tweaks

  constructor: (expressions) ->
    @tweaks = {}
    return unless expressions

    for expression in expressions.split(" ")
      [what, where] = expression.split(':')
      continue unless where

      if what.length == 1
        for piece_exp in new Cubexp(where).selected_pieces()
          for side in piece_exp.split('')
            this._add(piece_exp.toUpperCase(), side, what)
      else
        piece = standardize_name(where.toUpperCase())
        for side, i in where.split('')
          this._add(piece, side, what[i])


  for_sticker: (piece, side) ->
    match = @tweaks[standardize_name(piece)] || {}
    match[side_name(side)] || []

  _add: (piece, side, what) ->
    if Layer.side_by_name(side) # not lower case
      @tweaks[piece] ?= {}
      @tweaks[piece][side] ?= []
      @tweaks[piece][side].push(what)
