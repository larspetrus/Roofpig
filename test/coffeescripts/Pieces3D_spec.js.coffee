#= require three.min
#= require roofpig/Pieces3D

mock_scene    = { add: -> }
mock_settings = { hover: 1.0, colors: { at: -> { real: true, color: 'red'} } }

describe "Pieces3D", ->
  describe "#_piece_name", ->
    it "returns the right names, independent of order", ->
      Pieces3D._piece_name(Side.F, Side.R).should.equal("FR")
      Pieces3D._piece_name(Side.R, Side.F).should.equal("FR")
      Pieces3D._piece_name(Side.R, Side.F, Side.D).should.equal("DFR")

    it "ignores non official Sides", ->
      Pieces3D._piece_name(Side.F, "Bob", Side.R).should.equal("FR")

  it ".make_stickers() creates Pieces3D.UBL, Pieces3D.UL, Pieces3D.F etc", ->
    pieces = new Pieces3D(mock_scene, mock_settings)

    expect(pieces.UBL).to.be.defined
    expect(pieces.UL).to.be.defined
    expect(pieces.U).to.be.defined

    expect(pieces.BLU).to.be.undefined
    expect(pieces.WTF).to.be.undefined
    expect(pieces.LU).to.be.undefined
