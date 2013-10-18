#= require three.min
#= require roofpig/Side

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

class @Pieces3D
  @map: {}

  @make_stickers: (scene) ->
    mid_slice = new Side("-", v3(0.0, 0.0, 0.0))

    for x_side in [Side.R, mid_slice, Side.L]
      for y_side in [Side.F, mid_slice, Side.B]
        for z_side in [Side.U, mid_slice, Side.D]
          name = this._piece_name(x_side, y_side, z_side)
          new_piece = new THREE.Object3D()
          new_piece.name = name
          @map[name] = new_piece

          for side in [x_side, y_side, z_side]
            if side != mid_slice
              new_piece.add(side.make_sticker(this._piece_center(x_side, y_side, z_side)))
          scene.add(new_piece)

  @_piece_center: (x_side, y_side, z_side) ->
    v3(x_side.normal.x, y_side.normal.y, z_side.normal.z).multiplyScalar(2)

  @_piece_name: (sides...) ->
    code = ""
    for ordered_side in [Side.U, Side.D, Side.F, Side.B, Side.R, Side.L]
      if ordered_side in sides
        code += ordered_side.name
    return code
