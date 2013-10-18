#= require three.min

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Side
  constructor: (@name, @normal, @color) ->
    axis2 = v3(@normal.y, @normal.z, @normal.x)
    axix3 = v3(@normal.z, @normal.x, @normal.y)

    normal_sign = @normal.y + @normal.z + @normal.x
    @sx = axis2.clone().add(axix3).multiplyScalar(0.9 * normal_sign)
    @sy = axis2.clone().sub(axix3).multiplyScalar(0.9)

    @px = axis2.clone().add(axix3).multiplyScalar(1.0 * normal_sign)
    @py = axis2.clone().sub(axix3).multiplyScalar(1.0)

  make_sticker: (piece_center) ->
    sticker_center = piece_center.clone().add(@normal.clone().multiplyScalar(1.0001)) # Sticker hovers over plastic
    return new THREE.Mesh(this.square(sticker_center, @sx, @sy), new THREE.MeshBasicMaterial(color: @color))

  make_plastic: (piece_center) ->
    plastic_center = piece_center.clone().add(@normal) # stc = "sticker center"
    return new THREE.Mesh(this.square(plastic_center, @px, @py), new THREE.MeshBasicMaterial(color: 'black'))

  square: (stc, d1, d2) ->
    square = new THREE.Geometry();
    square.vertices.push(stc.clone().add(d1), stc.clone().add(d2), stc.clone().sub(d1), stc.clone().sub(d2));
    square.faces.push(new THREE.Face3(0, 1, 2), new THREE.Face3(0, 2, 3));
    square.computeBoundingSphere();
    return square

  @by_name: (name) ->
    all[name]

  @R: new Side('R', v3(-1, 0, 0), 'green')
  @L: new Side('L', v3( 1, 0, 0), 'blue')
  @F: new Side('F', v3( 0, 1, 0), 'red')
  @B: new Side('B', v3( 0,-1, 0), 'orange')
  @U: new Side('U', v3( 0, 0, 1), 'yellow')
  @D: new Side('D', v3( 0, 0,-1), '#ccc')

  all =
    R: @R
    L: @L
    F: @F
    B: @B
    D: @D
    U: @U
