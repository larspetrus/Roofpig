#= require roofpig/utils

class @Side
  constructor: (@name, @normal, @corner_cycle, @edge_cycle, center, @sticker_cycle) ->
    @positions = @corner_cycle.concat(@edge_cycle, center) if @corner_cycle

  @by_name: (name) ->
    all[name]

  @R: new Side('R', v3(-1, 0, 0), ['UFR','DFR','DBR','UBR'],['UR','FR','DR','BR'], ['R'], B:'D', D:'F', F:'U', U:'B', L:'L', R:'R')
  @L: new Side('L', v3( 1, 0, 0), ['UBL','DBL','DFL','UFL'],['BL','DL','FL','UL'], ['L'], B:'U', U:'F', F:'D', D:'B', L:'L', R:'R')
  @F: new Side('F', v3( 0, 1, 0), ['DFL','DFR','UFR','UFL'],['FL','DF','FR','UF'], ['F'], U:'R', R:'D', D:'L', L:'U', F:'F', B:'B')
  @B: new Side('B', v3( 0,-1, 0), ['UBL','UBR','DBR','DBL'],['UB','BR','DB','BL'], ['B'], U:'L', L:'D', D:'R', R:'U', F:'F', B:'B')
  @U: new Side('U', v3( 0, 0, 1), ['UBR','UBL','UFL','UFR'],['UR','UB','UL','UF'], ['U'], F:'R', R:'B', B:'L', L:'F', U:'U', D:'D')
  @D: new Side('D', v3( 0, 0,-1), ['DFR','DFL','DBL','DBR'],['DF','DL','DB','DR'], ['D'], F:'L', L:'B', B:'R', R:'F', U:'U', D:'D')

  shift: (side_name, turns) ->
    return null unless @sticker_cycle[side_name]
    throw new Error("Invalid turn number: '#{turns}'") if turns < 1

    result = side_name
    for n in [1..turns]
      result = @sticker_cycle[result]
    result

#  @M: new Side('M', Side.L.normal, [], [], [], Side.L.sticker_cycle)
#  @E: new Side('E', Side.D.normal, [], [], [], Side.D.sticker_cycle)
#  @S: new Side('S', Side.F.normal, [], [], [], Side.F.sticker_cycle)
#  @x: new Side('x', Side.R.normal)
#  @y: new Side('y', Side.U.normal)
#  @z: new Side('z', Side.F.normal)

  all = { R: @R, L: @L, F: @F, B: @B, D: @D, U: @U }
