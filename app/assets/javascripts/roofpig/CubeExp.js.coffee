#= require roofpig/utils

#Named in flawed analogy with RegExp
class @CubeExp

  PIECE_NAMES = ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']

  constructor: (expressions) ->
    @matches = {}
    if expressions
      for expression in expressions.split(" ")
        [exp, type_filter] = expression.split('/')
        piece_name = standardize_name(exp.toUpperCase())

        if exp[exp.length - 1] == "*"
          if exp.length == 4
            [s1, s2, s3] = [piece_name[0], piece_name[1], piece_name[2]]
            for piece in [s1+s2+s3, s1+s2, s1+s3, s2+s3, s1, s2, s3]
              this._add_match(piece, piece, type_filter)

          if exp.length == 2
            for piece in PIECE_NAMES
              if piece.indexOf(exp[0]) > -1
                this._add_match(piece, piece, type_filter)

          if exp.length == 1
            for piece in PIECE_NAMES
              this._add_match(piece, piece, type_filter)

        else
          if piece_name.length == 1 && piece_name != exp
            for piece in PIECE_NAMES
              if piece.indexOf(piece_name) > -1
                this._add_match(piece, piece_name, type_filter)
          else
            this._add_match(piece_name, standardize_name(exp), type_filter)

  _add_match: (piece, sides, type_filter) ->
    piece_type = 'mec'[piece.length-1]
    if not type_filter || type_filter.indexOf(piece_type) > -1
      @matches[piece] = sides

  matches_sticker: (piece_name, side) ->
    matching_stickers = @matches[standardize_name(piece_name)] || ""
    matching_stickers.indexOf(side_name(side)) > -1
