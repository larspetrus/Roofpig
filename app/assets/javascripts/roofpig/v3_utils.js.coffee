#= require three.min

@v3 = (x, y, z) -> new THREE.Vector3(x, y, z)

@v3_add = (v1, v2) -> v1.clone().add(v2)

@v3_sub = (v1, v2) -> v1.clone().sub(v2)