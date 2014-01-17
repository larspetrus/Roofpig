#= require three.min
#= require roofpig/Camera

describe "Camera", ->
  it "_POVs", ->
    Un = Side.U.normal
    Dn = Side.D.normal
    Fn = Side.F.normal
    Bn = Side.B.normal
    Rn = Side.R.normal
    Ln = Side.L.normal

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
