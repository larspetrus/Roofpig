#= require three.min
#= require Camera

describe "Camera", ->
  it "_POVs", ->
    Un = Layer.U.normal
    Dn = Layer.D.normal
    Fn = Layer.F.normal
    Bn = Layer.B.normal
    Rn = Layer.R.normal
    Ln = Layer.L.normal

    expect(Camera._POVs.Ufr).to.deep.equal({pos: v3(-25, 25, 25), up: Un, zn: Un, yn: Fn, xn: Rn} )
    expect(Camera._POVs.uFr).to.deep.equal({pos: v3(-25, 25, 25), up: Fn, zn: Fn, yn: Rn, xn: Un} )
    expect(Camera._POVs.dfL).to.deep.equal({pos: v3( 25, 25,-25), up: Ln, zn: Ln, yn: Dn, xn: Fn} )
    expect(Camera._POVs.dBl).to.deep.equal({pos: v3( 25,-25,-25), up: Bn, zn: Bn, yn: Dn, xn: Ln} )

    # Accept permutations
    expect(Camera._POVs.Ufr).to.equal(Camera._POVs.frU)
    expect(Camera._POVs.Ufr).to.equal(Camera._POVs.fUr)
    expect(Camera._POVs.Ufr).to.equal(Camera._POVs.rUf)
    expect(Camera._POVs.Ufr).to.equal(Camera._POVs.rfU)
    expect(Camera._POVs.Ufr).to.equal(Camera._POVs.Urf)
    expect(Camera._POVs.dBl).to.equal(Camera._POVs.Bld)

    # Don't expose the Side.normal vectors
    expect(Camera._POVs.Ufr.up).to.not.equal(Un)
    expect(Camera._POVs.Ufr.zn).to.not.equal(Un)
    expect(Camera._POVs.Ufr.yn).to.not.equal(Fn)
    expect(Camera._POVs.Ufr.xn).to.not.equal(Rn)

  it "#to_position", ->
    camera = new Camera(1.0, 'Ufr')
    camera.rotate(v3(1, 0, 0), 0.001)

    expect(camera.cam.position.y).to.not.equal(25) # confirm we're out of position

    camera.to_position()

    expect_v3(camera.cam.position, -25, 25, 25)
    expect_v3(camera.cam.up, 0, 0, 1)
    expect_v3(camera.user_dir.dr, -1, 0, 0)
    expect_v3(camera.user_dir.dl, 0, 1, 0)
    expect_v3(camera.user_dir.up, 0, 0, 1)

expect_v3 = (actual, x, y, z) ->
  expect(actual.toArray().join()).to.equal([x, y, z].join(), 999)
