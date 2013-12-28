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
    switch side
      when Side.U then [@at.UFR, @at.UFL, @at.UBR, @at.UBL, @at.UF, @at.UB, @at.UL, @at.UR, @at.U]
      when Side.D then [@at.DFR, @at.DFL, @at.DBR, @at.DBL, @at.DF, @at.DB, @at.DL, @at.DR, @at.D]
      when Side.F then [@at.UFL, @at.UFR, @at.DFR, @at.DFL, @at.UF, @at.FR, @at.DF, @at.FL, @at.F]
      when Side.B then [@at.UBL, @at.UBR, @at.DBR, @at.DBL, @at.UB, @at.BR, @at.DB, @at.BL, @at.B]
      when Side.L then [@at.UFL, @at.DFL, @at.DBL, @at.UBL, @at.UL, @at.FL, @at.DL, @at.BL, @at.L]
      when Side.R then [@at.UFR, @at.DFR, @at.DBR, @at.UBR, @at.UR, @at.FR, @at.DR, @at.BR, @at.R]

  move: (side, turns) ->
    switch side
      when Side.U
        this._track_stickers(side, turns, F:'R', R:'B', B:'L', L:'F', U:'U', D:'D')
        this._track_pieces(turns,['UBR','UBL','UFL','UFR'],['UR','UB','UL','UF'])
      when Side.D
        this._track_stickers(side, turns, F:'L', L:'B', B:'R', R:'F', U:'U', D:'D')
        this._track_pieces(turns,['DFR','DFL','DBL','DBR'],['DF','DL','DB','DR'])
      when Side.F
        this._track_stickers(side, turns, U:'R', R:'D', D:'L', L:'U', F:'F', B:'B')
        this._track_pieces(turns,['DFL','DFR','UFR','UFL'],['FL','DF','FR','UF'])
      when Side.B
        this._track_stickers(side, turns, U:'L', L:'D', D:'R', R:'U', F:'F', B:'B')
        this._track_pieces(turns,['UBL','UBR','DBR','DBL'],['UB','BR','DB','BL'])
      when Side.L
        this._track_stickers(side, turns, B:'U', U:'F', F:'D', D:'B', L:'L', R:'R')
        this._track_pieces(turns,['UBL','DBL','DFL','UFL'],['BL','DL','FL','UL'])
      when Side.R
        this._track_stickers(side, turns, B:'D', D:'F', F:'U', U:'B', L:'L', R:'R')
        this._track_pieces(turns,['UFR','DFR','DBR','UBR'],['UR','FR','DR','BR'])

  _track_stickers: (side, turns, map) ->
    for n in [1..turns]
      for piece in this.on(side)
        piece.sticker_locations = (map[item] for item in piece.sticker_locations)

  _track_pieces: (turns, corners, edges) ->
    if turns < 0
      turns += 4
    for n in [1..turns]
      this._permute(corners)
      this._permute(edges)

  _permute: (p) ->
    [@at[p[0]], @at[p[1]], @at[p[2]], @at[p[3]]] = [@at[p[1]], @at[p[2]], @at[p[3]], @at[p[0]]]
