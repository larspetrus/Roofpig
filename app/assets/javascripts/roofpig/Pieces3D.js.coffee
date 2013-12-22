#= require roofpig/Side
#= require roofpig/utils

# Pieces3D.UFR, Pieces3D.DL, Pieces3D.B etc refers to the 3D models for those pieces
class @Pieces3D
  constructor: (scene, settings) ->
    @at = {}
    this.make_stickers(scene, settings.hover, settings.colors)

    if (settings.setup)
      setup_alg = new Alg(settings.setup)
      until setup_alg.at_end()
        setup_alg.next_move().do(this)

  make_stickers: (scene, hover, colors) ->
    mid_slice = new Side("-", v3(0.0, 0.0, 0.0))

    for x_side in [Side.R, mid_slice, Side.L]
      for y_side in [Side.F, mid_slice, Side.B]
        for z_side in [Side.U, mid_slice, Side.D]
          name = standard_piece_name(x_side, y_side, z_side)
          new_piece = new THREE.Object3D()
          new_piece.name = name

          mid_point = this._piece_center(x_side, y_side, z_side)
          for side in [x_side, y_side, z_side]
            if side != mid_slice
              sticker = colors.to_draw(name, side)
              x_color = null
#              if name == 'UBR'
#                x_color = 'purple'

              side.make_sticker(new_piece, mid_point, sticker.color, x_color)

              if sticker.real && hover > 1
                side.make_reverse_sticker(new_piece, mid_point, sticker.color, hover, x_color)

              side.make_plastic(new_piece, mid_point)

          this[name] = @at[name] = new_piece
          scene.add(new_piece)

  _piece_center: (x_side, y_side, z_side) ->
    v3(x_side.normal.x, y_side.normal.y, z_side.normal.z).multiplyScalar(2)

  on: (side) ->
    return [@at.UFR, @at.UFL, @at.UBR, @at.UBL, @at.UF, @at.UB, @at.UL, @at.UR, @at.U]  if side == Side.U
    return [@at.DFR, @at.DFL, @at.DBR, @at.DBL, @at.DF, @at.DB, @at.DL, @at.DR, @at.D]  if side == Side.D
    return [@at.UFL, @at.UFR, @at.DFR, @at.DFL, @at.UF, @at.FR, @at.DF, @at.FL, @at.F]  if side == Side.F
    return [@at.UBL, @at.UBR, @at.DBR, @at.DBL, @at.UB, @at.BR, @at.DB, @at.BL, @at.B]  if side == Side.B
    return [@at.UFL, @at.DFL, @at.DBL, @at.UBL, @at.UL, @at.FL, @at.DL, @at.BL, @at.L]  if side == Side.L
    return [@at.UFR, @at.DFR, @at.DBR, @at.UBR, @at.UR, @at.FR, @at.DR, @at.BR, @at.R]  if side == Side.R

  move: (side, turns) ->
    this._move(turns,['UBR','UBL','UFL','UFR'],['UR','UB','UL','UF'])  if side == Side.U
    this._move(turns,['DFR','DFL','DBL','DBR'],['DF','DL','DB','DR'])  if side == Side.D
    this._move(turns,['DFL','DFR','UFR','UFL'],['FL','DF','FR','UF'])  if side == Side.F
    this._move(turns,['UBL','UBR','DBR','DBL'],['UB','BR','DB','BL'])  if side == Side.B
    this._move(turns,['UBL','DBL','DFL','UFL'],['BL','DL','FL','UL'])  if side == Side.L
    this._move(turns,['UFR','DFR','DBR','UBR'],['UR','FR','DR','BR'])  if side == Side.R

  _move: (turns, corners, edges) ->
    if turns < 0
      turns += 4
    for n in [1..turns]
      this._permute(corners)
      this._permute(edges)

  _permute: (p) ->
    [@at[p[0]], @at[p[1]], @at[p[2]], @at[p[3]]] = [@at[p[1]], @at[p[2]], @at[p[3]], @at[p[0]]]
