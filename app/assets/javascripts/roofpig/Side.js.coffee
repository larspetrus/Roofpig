#= require three.min

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Side
  constructor: (@name, @normal, @color) ->
    axis2 = v3(@normal.y, @normal.z, @normal.x)
    axix3 = v3(@normal.z, @normal.x, @normal.y)

    normal_sign = @normal.y + @normal.z + @normal.x
    @f1 = axis2.clone().add(axix3).multiplyScalar(0.9 * normal_sign)
    @f2 = axis2.clone().sub(axix3).multiplyScalar(0.9)

  make_sticker: (piece_center) ->
    stc = piece_center.clone().add(@normal) # stc = "sticker center"
    sticker = new THREE.Geometry();
    sticker.vertices.push(stc.clone().add(@f1), stc.clone().add(@f2), stc.clone().sub(@f1), stc.clone().sub(@f2));
    sticker.faces.push(new THREE.Face3(0, 1, 2), new THREE.Face3(0, 2, 3));
    sticker.computeBoundingSphere();

    return new THREE.Mesh(sticker, new THREE.MeshBasicMaterial(color: @color))

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
