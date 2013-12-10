#= require roofpig/utils

#Named in flawed analogy with RegExp
class @CubeExp

  PIECE_NAMES = ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']

  constructor: (expressions) ->
    @matches = {}
    if expressions
      for exp in expressions.split(" ")
        piece_name = standardize_name(exp.toUpperCase())

        if exp[exp.length - 1] == "*"
          if exp.length == 4
            [s1, s2, s3] = [piece_name[0], piece_name[1], piece_name[2]]
            for piece in [s1+s2+s3, s1+s2, s1+s3, s2+s3, s1, s2, s3]
              @matches[piece] = piece

          if exp.length == 2
            for piece in PIECE_NAMES
              if piece.indexOf(exp[0]) > -1
                @matches[piece] = piece
        else
          @matches[piece_name] = standardize_name(exp)
    else
      for piece in PIECE_NAMES
        @matches[piece] = piece


  matches_sticker: (piece_name, side) ->
    matching_stickers = @matches[standardize_name(piece_name)] || ""
    matching_stickers.indexOf(side_name(side)) > -1
