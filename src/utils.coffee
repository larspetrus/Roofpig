# --- Terser THREE.Vector3 ---

v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

v3_add = (v1, v2) -> v1.clone().add(v2)

v3_sub = (v1, v2) -> v1.clone().sub(v2)

v3_x = (v, factor) -> v.clone().multiplyScalar(factor)

# --- Piece names ---

standardize_name = (name) ->
  sides = [name[0], name[1], name[2]]

  result = ""
  for ordered_side in ['U', 'D', 'F', 'B', 'R', 'L']
    if ordered_side in sides
      result += ordered_side
  result

side_name = (side) ->
  if side then side.name || side else ""

# --- Logging ---

log_error = (text) ->
  console.log("RoofPig error: #{text}")
