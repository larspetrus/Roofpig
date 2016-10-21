#= require <utils.coffee>

class Layer
  constructor: (@name, @normal, @cycle1, @cycle2, uncycled, @sticker_cycle) ->
    @positions = @cycle1.concat(@cycle2, uncycled)

  @by_name: (name) ->
    all[name]

  @side_by_name: (name) ->
    sides[name]

  @R: new Layer('R', v3(-1, 0, 0), ['UFR','DFR','DBR','UBR'],['UR','FR','DR','BR'], ['R'], B:'D', D:'F', F:'U', U:'B', L:'L', R:'R')
  @L: new Layer('L', v3( 1, 0, 0), ['UBL','DBL','DFL','UFL'],['BL','DL','FL','UL'], ['L'], B:'U', U:'F', F:'D', D:'B', L:'L', R:'R')
  @F: new Layer('F', v3( 0, 1, 0), ['DFL','DFR','UFR','UFL'],['FL','DF','FR','UF'], ['F'], U:'R', R:'D', D:'L', L:'U', F:'F', B:'B')
  @B: new Layer('B', v3( 0,-1, 0), ['UBL','UBR','DBR','DBL'],['UB','BR','DB','BL'], ['B'], U:'L', L:'D', D:'R', R:'U', F:'F', B:'B')
  @U: new Layer('U', v3( 0, 0, 1), ['UBR','UBL','UFL','UFR'],['UR','UB','UL','UF'], ['U'], F:'R', R:'B', B:'L', L:'F', U:'U', D:'D')
  @D: new Layer('D', v3( 0, 0,-1), ['DFR','DFL','DBL','DBR'],['DF','DL','DB','DR'], ['D'], F:'L', L:'B', B:'R', R:'F', U:'U', D:'D')

  @M: new Layer('M', @L.normal, ['UF', 'UB', 'DB', 'DF'], ['U', 'B', 'D', 'F'], [], @L.sticker_cycle)
  @E: new Layer('E', @D.normal, ['BL', 'BR', 'FR', 'FL'], ['L', 'B', 'R', 'F'], [], @D.sticker_cycle)
  @S: new Layer('S', @F.normal, ['DL', 'DR', 'UR', 'UL'], ['L', 'D', 'R', 'U'], [], @F.sticker_cycle)

  shift: (side_name, turns) ->
    return null unless @sticker_cycle[side_name]
    throw new Error("Invalid turn number: '#{turns}'") if turns < 1

    result = side_name
    for n in [1..turns]
      result = @sticker_cycle[result]
    result

  on_same_axis_as: (other_layer) ->
    same_zeroes = 0
    for axis in ['x', 'y', 'z']
      if @normal[axis] == 0 && other_layer.normal[axis] == 0
        same_zeroes++
    same_zeroes == 2

  all = { R: @R, L: @L, F: @F, B: @B, D: @D, U: @U,    M: @M, E: @E, S:@S }
  sides = { R: @R, L: @L, F: @F, B: @B, D: @D, U: @U}
