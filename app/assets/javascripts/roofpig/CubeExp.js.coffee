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
        else
          log_error("Ignored unrecognized CubeExp '#{expression}'.")

  matches_sticker: (piece, side) ->
    @matches[standardize_name(piece)][side_name(side)]?

  selected_pieces: ->
    result = []
    for piece, selections of @matches
      code = ''
      selected = false
      for side in piece.split('')
        selected ||= selections[side]
        code += if selections[side] then side else side.toLowerCase()
      if selected then result.push(code)
    result

  _add_match: (piece, type_filter, sides = piece) ->
    piece_type = 'mec'[piece.length-1]
    if not type_filter || type_filter.indexOf(piece_type) > -1
      for side in sides.split('')
        @matches[piece][side] = true

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
        if exp == result.piece.toLowerCase()
          result.type = 'x'
        else
          result.type = 'XYZ'
          result.sides = standardize_name(exp) # removes lower case letters
    result