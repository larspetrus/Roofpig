#= require three.min

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Side
  constructor: (@name, @normal, @color) ->

  make_sticker: (piece_center, color) ->
    [dx, dy] = this._offsets(0.90, false)
    this._3d_square(this._square_center(piece_center, 1.0001), dx, dy, color)

  make_reverse_sticker: (piece_center, hover) ->
    [dx, dy] = this._offsets(0.98, true)
    this._3d_square(this._square_center(piece_center, hover), dx, dy, @color)

  make_plastic: (piece_center) ->
    [dx, dy] = this._offsets(1.0, true)
    this._3d_square(this._square_center(piece_center, 1), dx, dy, 'black')

  _square_center: (piece_center, distance) ->
    piece_center.clone().add(@normal.clone().multiplyScalar(distance))

  _3d_square: (stc, d1, d2, color) ->
    square = new THREE.Geometry();
    square.vertices.push(stc.clone().add(d1), stc.clone().add(d2), stc.clone().sub(d1), stc.clone().sub(d2));
    square.faces.push(new THREE.Face3(0, 1, 2), new THREE.Face3(0, 2, 3));
    square.computeBoundingSphere();
    new THREE.Mesh(square, new THREE.MeshBasicMaterial(color: color))

  _offsets: (sticker_size, reversed) ->
    axis2 = v3(@normal.y, @normal.z, @normal.x)
    axis3 = v3(@normal.z, @normal.x, @normal.y)
    flip = (@normal.y + @normal.z + @normal.x) * (if reversed then -1.0 else 1.0)

    dx = axis2.clone().add(axis3).multiplyScalar(sticker_size * flip)
    dy = axis2.clone().sub(axis3).multiplyScalar(sticker_size)
    [dx, dy]

  @by_name: (name) ->
    all[name]

  @R: new Side('R', v3(-1, 0, 0), '#0d0')
  @L: new Side('L', v3( 1, 0, 0), 'blue')
  @F: new Side('F', v3( 0, 1, 0), 'red')
  @B: new Side('B', v3( 0,-1, 0), 'orange')
  @U: new Side('U', v3( 0, 0, 1), 'yellow')
  @D: new Side('D', v3( 0, 0,-1), '#eee')

  all = { R: @R, L: @L, F: @F, B: @B, D: @D, U: @U }
