#= require roofpig/utils
#= require roofpig/Side

class @Camera
  DIST = 25

  constructor: (hover, @pov_code) ->
    @cam = new THREE.PerspectiveCamera(this._view_angle(hover, DIST), 1, 1, 100)
    this.to_pov()

  to_pov: ->
    pov = Camera._POVs[@pov_code]

    unless pov
      pov = Camera._POVs.Ufr
      log_error("Invalid POV '#{@pov_code}'. Using Ufr")

    @cam.position.copy(pov.pos)
    @cam.up.copy(pov.up)

    # Directions, as seen on the screen
    @user_dir =
      dr: pov.xn.clone() # dr == "down right"
      dl: pov.yn.clone() # dl == "down left"
      up: pov.zn.clone()
    this._cam_moved()


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
  
  @_POVs = do ->
    result = {}
    for z in [Side.U, Side.D]
      [zu, zl, zn] = [z.name, z.name.toLowerCase(), z.normal.clone()]
      for y in [Side.F, Side.B]
        [yu, yl, yn] = [y.name, y.name.toLowerCase(), y.normal.clone()]
        for x in [Side.R, Side.L]
          [xu, xl, xn] = [x.name, x.name.toLowerCase(), x.normal.clone()]

          pos = v3(xn.x, yn.y, zn.z).multiplyScalar(DIST)
          result[zu+yl+xl] = { pos: pos, up: zn, zn: zn, yn: yn, xn: xn }
          result[zl+yu+xl] = { pos: pos, up: yn, zn: zn, yn: yn, xn: xn }
          result[zl+yl+xu] = { pos: pos, up: xn, zn: zn, yn: yn, xn: xn }
    result

