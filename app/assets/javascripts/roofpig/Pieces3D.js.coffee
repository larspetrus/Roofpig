#= require roofpig/Side
#= require roofpig/utils

# Pieces3D.UFR, Pieces3D.DL, Pieces3D.B etc refers to the 3D models for those pieces
class @Pieces3D
  constructor: (scene, settings) ->
    @at = {}
    this.make_stickers(scene, settings.hover, settings.colors)

  make_stickers: (scene, hover, colors) ->
    mid_slice = new Side("-", v3(0.0, 0.0, 0.0))

    for x_side in [Side.R, mid_slice, Side.L]
      for y_side in [Side.F, mid_slice, Side.B]
        for z_side in [Side.U, mid_slice, Side.D]
          name = standard_piece_name(x_side, y_side, z_side)
          new_piece = new THREE.Object3D()
          new_piece.name = name
          new_piece.sticker_locations = name.split('')

          mid_point = this._piece_center(x_side, y_side, z_side)
          for side in [x_side, y_side, z_side]
            unless side == mid_slice
              sticker = colors.to_draw(name, side)

              side.make_sticker(new_piece, mid_point, sticker)

              if sticker.hovers && hover > 1
                side.make_reverse_sticker(new_piece, mid_point, sticker, hover)

              side.make_plastic(new_piece, mid_point, colors.of('plastic'))

          this[name] = @at[name] = new_piece
          scene.add(new_piece)

  _piece_center: (x_side, y_side, z_side) ->
    v3(x_side.normal.x, y_side.normal.y, z_side.normal.z).multiplyScalar(2)

  on: (side) ->
    (@at[position] for position in side.positions)

  move: (side, turns) ->
    positive_turns = (turns + 4) % 4
    this._track_stickers(side, positive_turns, side.sticker_cycle)
    this._track_pieces(positive_turns, side.cycle1, side.cycle2)

  state: ->
    result = ""
    for piece in ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']
      result += this[piece].sticker_locations.join('') + ' '
    result

  _track_stickers: (side, turns, map) ->
    for n in [1..turns]
      for piece in this.on(side)
        piece.sticker_locations = (map[item] for item in piece.sticker_locations)

  _track_pieces: (turns, cycle1, cycle2) ->
    for n in [1..turns]
      this._permute(cycle1)
      this._permute(cycle2)

  _permute: (p) ->
    [@at[p[0]], @at[p[1]], @at[p[2]], @at[p[3]]] = [@at[p[1]], @at[p[2]], @at[p[3]], @at[p[0]]]
