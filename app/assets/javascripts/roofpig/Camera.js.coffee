#= require three.min

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Camera

  constructor: (hover) ->
    coo = 25
    @cam = new THREE.PerspectiveCamera(this._fov(hover, coo), 1, 1, 100)

    @cam.position.set(coo, coo, coo)
    @cam.up.set(0,0,1);
    @cam.lookAt(v3(0, 0, 0))

    @viewer_x = v3(1, 0, 0)
    @viewer_y = v3(0, 1, 0)
    @viewer_z = v3(0, 0, 1)

  rotate: (axis, angle) ->
    for v in [@cam.position, @cam.up, @viewer_x, @viewer_y, @viewer_z]
      v.applyAxisAngle(axis, angle)
    @cam.lookAt(v3(0, 0, 0))

  _fov: (hover, cam_pos) ->
    max_cube_size = 2 * Math.sqrt(hover*hover + 4*hover + 13)
    dist = Math.sqrt(3*cam_pos*cam_pos) - 2
    2 * Math.atan(max_cube_size / (2 * dist)) * (180 / Math.PI)

