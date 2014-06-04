#= require roofpig/Side
#= require roofpig/utils

# Pieces3D.UFR, Pieces3D.DL, Pieces3D.B etc are the 3D models for those pieces
class @Pieces3D
  constructor: (scene, config) ->
    @at = {}
    this.make_stickers(scene, config.hover, config.colors)

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

  # ========= The 3D Factory =========

  make_stickers: (scene, hover, colors) ->
    slice = { normal: v3(0.0, 0.0, 0.0) }

    for x_side in [Side.R, slice, Side.L]
      for y_side in [Side.F, slice, Side.B]
        for z_side in [Side.U, slice, Side.D]
          name = standard_piece_name(x_side, y_side, z_side)
          new_3d_piece = new THREE.Object3D()
          new_3d_piece.name = name
          new_3d_piece.sticker_locations = name.split('')
          new_3d_piece.middle = v3(x_side.normal.x, y_side.normal.y, z_side.normal.z).multiplyScalar(2)

          for side in [x_side, y_side, z_side]
            unless side == slice
              sticker_look = colors.to_draw(name, side)

              this._add_sticker(side, new_3d_piece, sticker_look)
              this._add_hover_sticker(side, new_3d_piece, sticker_look, hover) if sticker_look.hovers && hover > 1
              this._add_plastic(side, new_3d_piece, colors.of('plastic'))

          this[name] = @at[name] = new_3d_piece
          scene.add(new_3d_piece)

  _add_sticker: (side, piece_3d, sticker) ->
    [dx, dy] = this._offsets(side, 0.90, false)
    piece_3d.add(this._3d_diamond(this._square_center(side, piece_3d.middle, 1.0002), dx, dy, sticker.color))

    if sticker.x_color
      this._add_X(side, piece_3d, sticker.x_color, 1.0004, true)

  _add_hover_sticker: (side, piece_3d, sticker, hover) ->
    [dx, dy] = this._offsets(side, 0.98, true)
    piece_3d.add(this._3d_diamond(this._square_center(side, piece_3d.middle, hover), dx, dy, sticker.color))

    if sticker.x_color
      this._add_X(side, piece_3d, sticker.x_color, hover - 0.0002, false)

  _add_X: (side, piece_3d, color, hover, reversed) ->
    [dx, dy] = this._offsets(side, 0.54, reversed)
    center = this._square_center(side, piece_3d.middle, hover)
    piece_3d.add(this._3d_rect(center, dx, v3_x(dy, 0.14), color))
    piece_3d.add(this._3d_rect(center, v3_x(dx, 0.14), dy, color))

  _add_plastic: (side, piece_3d, color) ->
    [dx, dy] = this._offsets(side, 1.0, true)
    piece_3d.add(this._3d_diamond(this._square_center(side, piece_3d.middle, 1), dx, dy, color))

  _square_center: (side, piece_center, distance) ->
    v3_add(piece_center, v3_x(side.normal, distance))

  _3d_diamond: (stc, d1, d2, color) ->
    this._3d_4side(v3_add(stc, d1), v3_add(stc, d2), v3_sub(stc, d1), v3_sub(stc, d2), color)

  _3d_rect: (stc, d1, d2, color) ->
    this._3d_diamond(stc, v3_add(d1, d2), v3_sub(d1, d2), color)

  _3d_4side: (v1, v2, v3 ,v4, color) ->
    geo = new THREE.Geometry();
    geo.vertices.push(v1, v2, v3 ,v4);
    geo.faces.push(new THREE.Face3(0, 1, 2), new THREE.Face3(0, 2, 3));

    # http://stackoverflow.com/questions/20734216/when-should-i-call-geometry-computeboundingbox-etc
    geo.computeFaceNormals();
    geo.computeBoundingSphere();

    new THREE.Mesh(geo, new THREE.MeshBasicMaterial(color: color))

  _offsets: (side, sticker_size, reversed) ->
    axis2 = v3(side.normal.y, side.normal.z, side.normal.x)
    axis3 = v3(side.normal.z, side.normal.x, side.normal.y)
    flip = (side.normal.y + side.normal.z + side.normal.x) * (if reversed then -1.0 else 1.0)

    dx = v3_add(axis2, axis3).multiplyScalar(sticker_size * flip)
    dy = v3_sub(axis2, axis3).multiplyScalar(sticker_size)
    [dx, dy]

