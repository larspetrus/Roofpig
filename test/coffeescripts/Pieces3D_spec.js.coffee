#= require roofpig/Pieces3D

describe "Pieces3D#_piece_name", ->
  it "returns the right names, independent of order", ->
    Pieces3D._piece_name(Side.F, Side.R).should.equal("FR")
    Pieces3D._piece_name(Side.R, Side.F).should.equal("FR")
    Pieces3D._piece_name(Side.R, Side.F, Side.D).should.equal("DFR")

  it "ignores non official Sides", ->
    Pieces3D._piece_name(Side.F, "Bob", Side.R).should.equal("FR")
