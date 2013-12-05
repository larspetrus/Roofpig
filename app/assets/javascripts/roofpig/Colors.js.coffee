#= require roofpig/Side

class @Colors

  constructor: (colored, solved) ->
    @colored = Colors._expand(colored)
    @solved = Colors._expand(solved || "n/a")

  at: (piece_name, side) ->
    if Colors._selected_sticker(@solved, piece_name)
      { real: false, color: this.of('solved') }
    else if Colors._selected_sticker(@colored, piece_name)
      { real: true, color: this.of(side) }
    else
      { real: false, color: this.of('ignored') }

  of: (sticker_type) ->
    switch sticker_type
      when Side.R    then '#0d0'  # green
      when Side.L    then 'blue'
      when Side.F    then 'red'
      when Side.B    then 'orange'
      when Side.U    then 'yellow'
      when Side.D    then '#eee' # white
      when 'solved'  then '#666' # dark grey
      when 'ignored' then '#aaa' # light gray
      else
        throw new Error("Unknown sticker type #{sticker_type}")

  @_selected_sticker: (selection, piece_name) ->
    selection.indexOf(" #{piece_name} ") > -1

  PIECE_NAMES = ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']
  @_expand: (expressions) ->
    return " #{PIECE_NAMES.join(' ')} " unless expressions

    result = " "
    for exp in expressions.split(" ")
      if exp.charAt(exp.length - 1) == "*"
        if exp.length == 4
          c1 = exp.charAt(0)
          c2 = exp.charAt(1)
          c3 = exp.charAt(2)
          result += c1+c2+c3+" "+c1+c2+" "+c1+c3+" "+c2+c3+" "+c1+" "+c2+" "+c3+" "
        if exp.length == 2
          for name in PIECE_NAMES
            if name.indexOf(exp.charAt(0)) > -1
              result += name + " "
      else
        result += exp + " "
    result