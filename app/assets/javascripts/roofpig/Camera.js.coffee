#= require roofpig/utils

class @Camera

  constructor: (hover) ->
    coord = 25
    @cam = new THREE.PerspectiveCamera(this._view_angle(hover, coord), 1, 1, 100)

    @cam.position.set(-coord, coord, coord)
    @cam.up.set(0,0,1);
    this._cam_moved()

    # Directions, as seen on the screen
    @user_dir =
       dr: v3(-1, 0, 0) # dr == "down right"
       dl: v3( 0, 1, 0) # dl == "down left"
       up: v3( 0, 0, 1)

  rotate: (axis, angle) ->
    for v in [@cam.position, @cam.up, @user_dir.dl, @user_dir.dr, @user_dir.up]
      v.applyAxisAngle(axis, angle)
    this._cam_moved()

  bend: (dx, dy) ->
    v1 = v3_x(@user_dir.up, dx)
    v2 = v3_sub(@user_dir.dr, @user_dir.dl).normalize().multiplyScalar(dy)
    axis = v3_add(v1, v2).normalize()

    @cam.position = @unbent_position.clone()
    @cam.up = @unbent_up.clone()
    for v in [@cam.position, @cam.up]
      v.applyAxisAngle(axis, Math.sqrt(dx*dx + dy*dy))
    @cam.lookAt(v3(0, 0, 0))

  _view_angle: (hover, cam_pos) ->
    max_cube_size = 2 * Math.sqrt(hover*hover + 4*hover + 13)
    distance = Math.sqrt(3*cam_pos*cam_pos) - 2
    adjustment_factor = 1.015 + 0.13 * (5-hover)/4 # I don't understand the math, but this looks OK
    adjustment_factor * 2 * Math.atan(max_cube_size / (2*distance)) * (180 / Math.PI)

  _cam_moved: ->
    @cam.lookAt(v3(0, 0, 0))
    @unbent_up = @cam.up.clone()
    @unbent_position = @cam.position.clone()