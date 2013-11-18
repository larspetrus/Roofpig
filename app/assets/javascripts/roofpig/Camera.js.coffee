#= require roofpig/v3_utils

class @Camera

  constructor: (hover) ->
    coord = 25
    @cam = new THREE.PerspectiveCamera(this._fov(hover, coord), 1, 1, 100)

    @cam.position.set(coord, coord, coord)
    @cam.up.set(0,0,1);
    @cam.lookAt(v3(0, 0, 0))

    @viewer_dir =
       x: v3(1, 0, 0)
       y: v3(0, 1, 0)
       z: v3(0, 0, 1)

  rotate: (axis, angle) ->
    for v in [@cam.position, @cam.up, @viewer_dir.x, @viewer_dir.y, @viewer_dir.z]
      v.applyAxisAngle(axis, angle)
    @cam.lookAt(v3(0, 0, 0))

  _fov: (hover, cam_pos) ->
    max_cube_size = 2 * Math.sqrt(hover*hover + 4*hover + 13)
    dist = Math.sqrt(3*cam_pos*cam_pos) - 2
    2 * Math.atan(max_cube_size / (2 * dist)) * (180 / Math.PI)

