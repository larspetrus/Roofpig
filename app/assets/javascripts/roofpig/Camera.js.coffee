#= require three.min

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Camera

  constructor: ->
    @cam = new THREE.PerspectiveCamera(24, 1, 1, 100)

    @cam.position.set(25, 25, 25)
    @cam.up.set(0,0,1);
    @cam.lookAt(v3(0, 0, 0))

    @viewer_x = v3(1, 0, 0)
    @viewer_y = v3(0, 1, 0)
    @viewer_z = v3(0, 0, 1)

  rotate: (axis, angle) ->
    for v in [@cam.position, @cam.up, @viewer_x, @viewer_y, @viewer_z]
      v.applyAxisAngle(axis, angle)

    @cam.lookAt(v3(0, 0, 0))
