#= require utils
#= require Layer

class Camera
  DISTANCE = 25

  constructor: (hover, pov_code) ->
    @cam = new THREE.PerspectiveCamera(this._view_angle(hover, DISTANCE), 1, 1, 100)

    pov = Camera._POVs[pov_code]
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

  to_position: ->
    for v in [@cam.position, @cam.up, @user_dir.dl, @user_dir.dr, @user_dir.up]
      [v.x, v.y, v.z] = [Math.round(v.x), Math.round(v.y), Math.round(v.z)]
    
  bend: (dx, dy) ->
    v1 = v3_x(@user_dir.up, dx)
    v2 = v3_sub(@user_dir.dr, @user_dir.dl).normalize().multiplyScalar(dy)
    axis = v3_add(v1, v2).normalize()

    @cam.position.copy(@unbent_position)
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

  @_flip: (pov, parity) ->
    if (parity > 0)
      [pov.xn, pov.yn] = [pov.yn, pov.xn]
    pov

  @_set_perms: (povs, a, b, c, value) ->
    povs[a+b+c] = povs[a+c+b] = povs[b+a+c] = povs[b+c+a] = povs[c+a+b] = povs[c+b+a] = value


  @_POVs = do ->
    result = {}
    for z in [Layer.U, Layer.D]
      [zu, zl, zn] = [z.name, z.name.toLowerCase(), z.normal.clone()]
      for y in [Layer.F, Layer.B]
        [yu, yl, yn] = [y.name, y.name.toLowerCase(), y.normal.clone()]
        for x in [Layer.R, Layer.L]
          [xu, xl, xn] = [x.name, x.name.toLowerCase(), x.normal.clone()]

          pos = v3(xn.x, yn.y, zn.z).multiplyScalar(DISTANCE)
          parity = xn.x * yn.y * zn.z

          Camera._set_perms(result, zu, yl, xl, Camera._flip({ pos: pos, up: zn, zn: zn, yn: yn, xn: xn }, parity))
          Camera._set_perms(result, zl, yu, xl, Camera._flip({ pos: pos, up: yn, zn: yn, yn: xn, xn: zn }, parity))
          Camera._set_perms(result, zl, yl, xu, Camera._flip({ pos: pos, up: xn, zn: xn, yn: zn, xn: yn }, parity))
    result
