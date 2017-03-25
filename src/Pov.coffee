# POV = Point Of View. Cube notations has two POVs.
#
# Seen from the cube, U is always up, and there are only six kinds of moves: B, R, D, F, L, and U.
# Seen from the hands of a human, more moves exist (x, y, x, M, E, S, etc), and after a z2 move,
# U seen from the cube is D seen from the hands.
#
# This class keeps track of and maps between these POVs

class Pov
  constructor: (moves) ->
    @map = Pov.start_map()
    this.track(moves) if moves

  @start_map: ->
    {B: 'B', D: 'D', F: 'F',L: 'L', R: 'R', U: 'U'}

  track: (moves) ->
    moves = [moves] unless Array.isArray(moves)
    for move in moves
      move.track_pov(@map)

  hand_to_cube_map: ->
    reverse_map = {}
    for own key, value of @map
      reverse_map[value] = key
    reverse_map

  cube_to_hand: (code) ->
    this._case_map(@map, code)

  hand_to_cube: (code) ->
    this._case_map(this.hand_to_cube_map(), code)

  _case_map: (map, code) ->
    return code unless code
    (map[char] || map[char.toUpperCase()]?.toLowerCase() || char for char in code.split('')).join('')
