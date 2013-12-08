#= require roofpig/Pieces3D

#The name is a flawed analogy with RegExps
class @CubeExp

  PIECE_NAMES = ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']

  constructor: (expressions) ->
    if expressions
      @stringthing = " "
      for exp in expressions.split(" ")
        if exp[exp.length - 1] == "*"
          if exp.length == 4
            nmz = Pieces3D.piece_name(exp[0], exp[1], exp[2])
            [c1, c2, c3] = [nmz[0], nmz[1], nmz[2]]
            @stringthing += c1+c2+c3+" "+c1+c2+" "+c1+c3+" "+c2+c3+" "+c1+" "+c2+" "+c3+" "
          if exp.length == 2
            for name in PIECE_NAMES
              if name.indexOf(exp[0]) > -1
                @stringthing += name + " "
        else
          @stringthing += Pieces3D.piece_name(exp[0], exp[1], exp[2]) + " "
    else
      @stringthing = " #{PIECE_NAMES.join(' ')} "


  matches_sticker: (piece_name, side) ->
    normalized_name = Pieces3D.piece_name(piece_name[0], piece_name[1], piece_name[2])
    @stringthing.indexOf(" #{normalized_name} ") > -1
