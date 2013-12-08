#= require three.min
#= require roofpig/Pieces3D

mock_scene    = { add: -> }
mock_settings = { hover: 1.0, colors: { to_draw: -> { real: true, color: 'red'} } }

describe "Pieces3D", ->
  it ".make_stickers() creates Pieces3D.UBL, Pieces3D.UL, Pieces3D.F etc", ->
    pieces = new Pieces3D(mock_scene, mock_settings)

    expect(pieces.UBL).to.be.defined
    expect(pieces.UL).to.be.defined
    expect(pieces.U).to.be.defined

    expect(pieces.BLU).to.be.undefined
    expect(pieces.WTF).to.be.undefined
    expect(pieces.LU).to.be.undefined
