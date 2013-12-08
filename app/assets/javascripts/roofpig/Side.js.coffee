#= require roofpig/utils

class @Side
  constructor: (@name, @normal) ->

  make_sticker: (piece_center, color) ->
    [dx, dy] = this._offsets(0.90, false)
    this._3d_square(this._square_center(piece_center, 1.0001), dx, dy, color)

  make_reverse_sticker: (piece_center, color, hover) ->
    [dx, dy] = this._offsets(0.98, true)
    this._3d_square(this._square_center(piece_center, hover), dx, dy, color)

  make_plastic: (piece_center) ->
    [dx, dy] = this._offsets(1.0, true)
    this._3d_square(this._square_center(piece_center, 1), dx, dy, 'black')

  _square_center: (piece_center, distance) ->
    v3_add(piece_center, @normal.clone().multiplyScalar(distance))

  _3d_square: (stc, d1, d2, color) ->
    square = new THREE.Geometry();
    square.vertices.push(v3_add(stc, d1), v3_add(stc, d2), v3_sub(stc, d1), v3_sub(stc, d2));
    square.faces.push(new THREE.Face3(0, 1, 2), new THREE.Face3(0, 2, 3));
    square.computeBoundingSphere();
    new THREE.Mesh(square, new THREE.MeshBasicMaterial(color: color))

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
