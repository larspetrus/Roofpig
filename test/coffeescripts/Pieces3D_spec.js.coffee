#= require three.min
#= require roofpig/Pieces3D

mock_scene    = { add: -> }
mock_settings = { hover: 1.0, colors: { to_draw: -> { real: true, color: 'red'} } }

describe "Pieces3D", ->
  describe "#piece_name", ->
    it "returns the right names, independent of order", ->
      Pieces3D.piece_name('F', 'R').should.equal("FR")
      Pieces3D.piece_name('R', 'F').should.equal("FR")
      Pieces3D.piece_name('R', 'F', 'D').should.equal("DFR")

    it "ignores non official Sides", ->
      Pieces3D.piece_name('F', 'Bob', 'R').should.equal("FR")

  it ".make_stickers() creates Pieces3D.UBL, Pieces3D.UL, Pieces3D.F etc", ->
    pieces = new Pieces3D(mock_scene, mock_settings)

    expect(pieces.UBL).to.be.defined
    expect(pieces.UL).to.be.defined
    expect(pieces.U).to.be.defined

    expect(pieces.BLU).to.be.undefined
    expect(pieces.WTF).to.be.undefined
    expect(pieces.LU).to.be.undefined
