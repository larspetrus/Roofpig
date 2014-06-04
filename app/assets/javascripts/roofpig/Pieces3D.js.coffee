#= require roofpig/Side
#= require roofpig/utils

# Pieces3D.UFR, Pieces3D.DL, Pieces3D.B etc are the 3D models for those pieces
class @Pieces3D
  constructor: (scene, config) ->
    @at = {}
    this.make_stickers(scene, config.hover, config.colors)

  make_stickers: (scene, hover, colors) ->
    mid_slice = new Side("-", v3(0.0, 0.0, 0.0))

    for x_side in [Side.R, mid_slice, Side.L]
      for y_side in [Side.F, mid_slice, Side.B]
        for z_side in [Side.U, mid_slice, Side.D]
          name = standard_piece_name(x_side, y_side, z_side)
          new_3d_piece = new THREE.Object3D()
          new_3d_piece.name = name
          new_3d_piece.sticker_locations = name.split('')
          new_3d_piece.middle = v3(x_side.normal.x, y_side.normal.y, z_side.normal.z).multiplyScalar(2)

          for side in [x_side, y_side, z_side]
            unless side == mid_slice
              sticker_look = colors.to_draw(name, side)

              side.make_sticker(new_3d_piece, sticker_look)

              if sticker_look.hovers && hover > 1
                side.make_hover_sticker(new_3d_piece, sticker_look, hover)

              side.make_plastic(new_3d_piece, colors.of('plastic'))

          this[name] = @at[name] = new_3d_piece
          scene.add(new_3d_piece)

  on: (side) ->
    (@at[position] for position in side.positions)

  move: (side, turns) ->
    positive_turns = (turns + 4) % 4
    this._track_stickers(side, positive_turns)
    this._track_pieces(positive_turns, side.corner_cycle, side.edge_cycle)

  state: ->
    result = ""
    for piece in ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']
      result += this[piece].sticker_locations.join('') + ' '
    result

  _track_stickers: (side, turns) ->
    for piece in this.on(side)
      piece.sticker_locations = (side.shift(item, turns) for item in piece.sticker_locations)

  _track_pieces: (turns, corner_cycle, edge_cycle) ->
    for n in [1..turns]
      this._permute(corner_cycle)
      this._permute(edge_cycle)

  _permute: (p) ->
    [@at[p[0]], @at[p[1]], @at[p[2]], @at[p[3]]] = [@at[p[1]], @at[p[2]], @at[p[3]], @at[p[0]]]
