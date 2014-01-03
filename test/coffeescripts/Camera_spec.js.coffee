#= require three.min
#= require roofpig/Camera

describe "Camera", ->
  it "_POVs", ->
    u_norm = Side.U.normal
    d_norm = Side.D.normal
    f_norm = Side.F.normal
    r_norm = Side.R.normal
    l_norm = Side.L.normal

    expect(Camera._POVs['Ufr'], 1).to.deep.equal({pos: v3(-25, 25, 25), up: u_norm, zn: u_norm, yn: f_norm, xn: r_norm} )
    expect(Camera._POVs['uFr'], 2).to.deep.equal({pos: v3(-25, 25, 25), up: f_norm, zn: u_norm, yn: f_norm, xn: r_norm} )
    expect(Camera._POVs['dfL'], 3).to.deep.equal({pos: v3( 25, 25,-25), up: l_norm, zn: d_norm, yn: f_norm, xn: l_norm} )

    # Don't expose the Side.normal vectors
    expect(Camera._POVs['Ufr'].up  , 4).to.not.equal(u_norm)
    expect(Camera._POVs['Ufr'].zn, 5).to.not.equal(u_norm)
    expect(Camera._POVs['Ufr'].yn, 6).to.not.equal(f_norm)
    expect(Camera._POVs['Ufr'].xn, 7).to.not.equal(r_norm)
