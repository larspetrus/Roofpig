@v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

@v3_add = (v1, v2) -> v1.clone().add(v2)

@v3_sub = (v1, v2) -> v1.clone().sub(v2)

@standard_piece_name = (sides...) ->
  name = ""
  for ordered_side in ['U', 'D', 'F', 'B', 'R', 'L']
    if ordered_side in sides
      name += ordered_side
  name

