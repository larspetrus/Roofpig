#= require Layer
#= require utils

# Pieces3D.UFR, Pieces3D.DL, Pieces3D.B etc are the 3D models for those pieces
class Pieces3D
  TINY = 0.0030

  constructor: (scene, hover, colors, @use_canvas) ->
    @at = {}
    @cube_surfaces = if @use_canvas then [true] else [true, false]
    @sticker_size  = if @use_canvas then 0.84 else 0.90
    @hover_size    = if @use_canvas then 0.91 else 0.97
    this.make_stickers(scene, hover, colors)

  on: (layer) ->
    (@at[position] for position in layer.positions)

  move: (layer, turns) ->
    positive_turns = (turns + 4) % 4
    this._track_stickers(layer, positive_turns)
    this._track_pieces(positive_turns, layer.cycle1, layer.cycle2)

  state: ->
    result = ""
    for piece in ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']
      result += this[piece].sticker_locations.join('') + ' '
    result

  _track_stickers: (layer, turns) ->
    for piece in this.on(layer)
      piece.sticker_locations = (layer.shift(item, turns) for item in piece.sticker_locations)

  _track_pieces: (turns, cycle1, cycle2) ->
    for n in [1..turns]
      this._permute(cycle1)
      this._permute(cycle2)

  _permute: (p) ->
    [@at[p[0]], @at[p[1]], @at[p[2]], @at[p[3]]] = [@at[p[1]], @at[p[2]], @at[p[3]], @at[p[0]]]

  # ========= The 3D Factory =========

  make_stickers: (scene, hover, colors) ->
    slice = { normal: v3(0.0, 0.0, 0.0), name: '-' }

    for x_side in [Layer.R, slice, Layer.L]
      for y_side in [Layer.F, slice, Layer.B]
        for z_side in [Layer.U, slice, Layer.D]
          piece = this._new_piece(x_side, y_side, z_side)

          for side in [x_side, y_side, z_side]
            unless side == slice
              sticker_look = colors.to_draw(piece.name, side)

              this._add_sticker(side, piece, sticker_look)
              this._add_hover_sticker(side, piece, sticker_look, hover) if sticker_look.hovers && hover > 1
              this._add_cubeside(side, piece, colors.of('cube'))

          this[piece.name] = @at[piece.name] = piece
          scene.add(piece)

  _new_piece: (x_side, y_side, z_side) ->
    new_piece = new THREE.Object3D()
    new_piece.name = standardize_name(x_side.name + y_side.name + z_side.name)
    new_piece.sticker_locations = new_piece.name.split('')
    new_piece.middle = v3(2*x_side.normal.x, 2*y_side.normal.y, 2*z_side.normal.z)
    new_piece

  _add_sticker: (side, piece_3d, sticker) ->
    [dx, dy] = this._offsets(side.normal, @sticker_size, false)
    piece_3d.add(this._diamond(this._square_center(side, piece_3d.middle, 1+TINY), dx, dy, sticker.color))

    if sticker.x_color
      this._add_X(side, piece_3d, sticker.x_color, 1+2*TINY, true)

  _add_hover_sticker: (side, piece_3d, sticker, hover) ->
    [dx, dy] = this._offsets(side.normal, @hover_size, true)
    piece_3d.add(this._diamond(this._square_center(side, piece_3d.middle, hover), dx, dy, sticker.color))

    if sticker.x_color
      this._add_X(side, piece_3d, sticker.x_color, hover-TINY, false)

  _add_cubeside: (side, piece_3d, color) ->
    for reversed in @cube_surfaces
      [dx, dy] = this._offsets(side.normal, 1.0, reversed)
      piece_3d.add(this._diamond(this._square_center(side, piece_3d.middle, 1), dx, dy, color))

  _add_X: (side, piece_3d, color, distance, reversed) ->
    [dx, dy] = this._offsets(side.normal, 0.54, reversed)
    center = this._square_center(side, piece_3d.middle, distance)
    piece_3d.add(this._rect(center, dx, v3_x(dy, 0.14), color))
    piece_3d.add(this._rect(center, v3_x(dx, 0.14), dy, color))

  _square_center: (side, piece_center, distance) ->
    v3_add(piece_center, v3_x(side.normal, distance))

  _rect: (center, d1, d2, color) ->
    this._diamond(center, v3_add(d1, d2), v3_sub(d1, d2), color)

  _diamond: (center, d1, d2, color) ->
    geo = new THREE.Geometry();
    geo.vertices.push(v3_add(center, d1), v3_add(center, d2), v3_sub(center, d1), v3_sub(center, d2));
    geo.faces.push(new THREE.Face3(0, 1, 2), new THREE.Face3(0, 2, 3));

    # http://stackoverflow.com/questions/20734216/when-should-i-call-geometry-computeboundingbox-etc
    geo.computeFaceNormals();
    geo.computeBoundingSphere();

    new THREE.Mesh(geo, new THREE.MeshBasicMaterial(color: color, overdraw: 0.8))

  _offsets: (axis1, sticker_size, reversed) ->
    axis2 = v3(axis1.y, axis1.z, axis1.x)
    axis3 = v3(axis1.z, axis1.x, axis1.y)
    flip = (axis1.y + axis1.z + axis1.x) * (if reversed then -1.0 else 1.0)

    dx = v3_add(axis2, axis3).multiplyScalar(sticker_size * flip)
    dy = v3_sub(axis2, axis3).multiplyScalar(sticker_size)
    [dx, dy]