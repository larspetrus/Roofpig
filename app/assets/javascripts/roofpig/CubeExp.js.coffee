#= require roofpig/utils

#Named in flawed analogy with RegExp
class @CubeExp

  PIECE_NAMES = ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']

  constructor: (expressions = "") ->
    @matches = {}
    for piece in PIECE_NAMES
      @matches[piece] = {}

    for expression in expressions.split(" ")
      exp = this._parse(expression)

      switch exp.type
        when 'XYZ'
          this._add_match(exp.piece, exp.type_filter, exp.sides)
        when 'XYZ*'
          [s1, s2, s3] = exp.piece.split('')
          for piece in [s1+s2+s3, s1+s2, s1+s3, s2+s3, s1, s2, s3]
            this._add_match(piece, exp.type_filter)
        when 'X-'
          for piece in PIECE_NAMES
            excluded = false
            for side in exp.sides.split('')
              excluded ||= piece.indexOf(side) > -1
            unless excluded
              this._add_match(piece, exp.type_filter)

        when 'X*'
          for piece in PIECE_NAMES
            if piece.indexOf(exp.piece[0]) > -1
              this._add_match(piece, exp.type_filter)
        when '*'
          for piece in PIECE_NAMES
            this._add_match(piece, exp.type_filter)
        when 'x'
          for piece in PIECE_NAMES
            if piece.indexOf(exp.piece[0]) > -1
              this._add_match(piece, exp.type_filter, exp.piece)
        when 'XYZ:abc'
          for side, i in exp.sides.split('')
            if Side.by_name(side)
              this._add_match(exp.piece, exp.type_filter, side, exp.tweaks[i])

        else
          log_error("Ignored unrecognized CubeExp '#{expression}'.")

  _add_match: (piece, type_filter, sides = piece, value = true) ->
    piece_type = 'mec'[piece.length-1]
    if not type_filter || type_filter.indexOf(piece_type) > -1
      for side in sides.split('')
        mp = @matches[piece]
        if mp[side] && mp[side] != true # TODO: Concepts collide here...
          mp[side] += value
        else
          mp[side] = value

  _parse: (expression) ->
    result = {}
    [exp, result.type_filter] = expression.split('/')
    result.piece = standardize_name(exp.toUpperCase())

    switch exp[exp.length - 1]
      when "*"
        result.type = ['*', 'X*', '', 'XYZ*'][exp.length - 1]
      when "-"
        result.type = 'X-'
        result.sides = standardize_name(exp) # removes the '-'
      else
        if exp.indexOf(':') > -1
          result.type = 'XYZ:abc'
          [result.sides, result.tweaks] = exp.split(':')
          result.piece = standardize_name(result.sides.toUpperCase())
        else
          if exp == result.piece.toLowerCase()
            result.type = 'x'
          else
            result.type = 'XYZ'
            result.sides = standardize_name(exp) # removes lower case letters
    result

  for_sticker: (piece, side) ->
    @matches[standardize_name(piece)][side_name(side)]

  matches_sticker: (piece, side) ->
    @matches[standardize_name(piece)][side_name(side)]?
