# --- Terser THREE.Vector3 ---

@v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

@v3_add = (v1, v2) -> v1.clone().add(v2)

@v3_sub = (v1, v2) -> v1.clone().sub(v2)

@v3_x = (v, factor) -> v.clone().multiplyScalar(factor)

# --- Piece names ---

@standard_piece_name = (sides...) ->
  side_names = sides.map (side) -> side_name(side)

  name = ""
  for ordered_side in ['U', 'D', 'F', 'B', 'R', 'L']
    if ordered_side in side_names
      name += ordered_side
  name

@standardize_name = (name) ->
  standard_piece_name(name[0], name[1], name[2])

@side_name = (side) ->
  if side then side.name || side else ""

# --- Logging ---

@log_error = (text) ->
  console.log("RoofPig error: #{text}")