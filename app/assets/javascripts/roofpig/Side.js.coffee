#= require roofpig/utils

class @Side
  constructor: (@name, @normal) ->

  make_sticker: (obj_3d, piece_center, sticker) ->
    [dx, dy] = this._offsets(0.90, false)
    obj_3d.add(this._3d_diamond(this._square_center(piece_center, 1.0002), dx, dy, sticker.color))

    if sticker.x_color
      this.make_X(obj_3d, piece_center, sticker.x_color, 1.0004, true)

  make_reverse_sticker: (obj_3d, piece_center, sticker, hover) ->
    [dx, dy] = this._offsets(0.98, true)
    obj_3d.add(this._3d_diamond(this._square_center(piece_center, hover), dx, dy, sticker.color))

    if sticker.x_color
      this.make_X(obj_3d, piece_center, sticker.x_color, hover - 0.0002, false)

  make_X: (obj_3d, piece_center, color, hover, reversed) ->
    [dx, dy] = this._offsets(0.54, reversed)
    center = this._square_center(piece_center, hover)
    obj_3d.add(this._3d_rect(center, dx, v3_x(dy, 0.14), color))
    obj_3d.add(this._3d_rect(center, v3_x(dx, 0.14), dy, color))

  make_plastic: (obj_3d, piece_center, color) ->
    [dx, dy] = this._offsets(1.0, true)
    obj_3d.add(this._3d_diamond(this._square_center(piece_center, 1), dx, dy, color))

  _square_center: (piece_center, distance) ->
    v3_add(piece_center, @normal.clone().multiplyScalar(distance))

  _3d_diamond: (stc, d1, d2, color) ->
    this._3d_4side(v3_add(stc, d1), v3_add(stc, d2), v3_sub(stc, d1), v3_sub(stc, d2), color)

  _3d_rect: (stc, d1, d2, color) ->
    this._3d_diamond(stc, v3_add(d1, d2), v3_sub(d1, d2), color)

  _3d_4side: (v1, v2, v3 ,v4, color) ->
    geo = new THREE.Geometry();
    geo.vertices.push(v1, v2, v3 ,v4);
    geo.faces.push(new THREE.Face3(0, 1, 2), new THREE.Face3(0, 2, 3));
    geo.computeBoundingSphere(); #TODO Kill?
    new THREE.Mesh(geo, new THREE.MeshBasicMaterial(color: color))

  _offsets: (sticker_size, reversed) ->
    axis2 = v3(@normal.y, @normal.z, @normal.x)
    axis3 = v3(@normal.z, @normal.x, @normal.y)
    flip = (@normal.y + @normal.z + @normal.x) * (if reversed then -1.0 else 1.0)

    dx = v3_add(axis2, axis3).multiplyScalar(sticker_size * flip)
    dy = v3_sub(axis2, axis3).multiplyScalar(sticker_size)
    [dx, dy]

  @by_name: (name) ->
    all[name]

  @R: new Side('R', v3(-1, 0, 0))
  @L: new Side('L', v3( 1, 0, 0))
  @F: new Side('F', v3( 0, 1, 0))
  @B: new Side('B', v3( 0,-1, 0))
  @U: new Side('U', v3( 0, 0, 1))
  @D: new Side('D', v3( 0, 0,-1))

  all = { R: @R, L: @L, F: @F, B: @B, D: @D, U: @U }
