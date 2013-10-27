#= require roofpig/Pieces3D

describe "Pieces3D#_piece_name", ->
  it "returns the right names, independent of order", ->
    Pieces3D._piece_name(Side.F, Side.R).should.equal("FR")
    Pieces3D._piece_name(Side.R, Side.F).should.equal("FR")
    Pieces3D._piece_name(Side.R, Side.F, Side.D).should.equal("DFR")

  it "ignores non official Sides", ->
    Pieces3D._piece_name(Side.F, "Bob", Side.R).should.equal("FR")

it ".make_stickers() creates Pieces3D.UBL, Pieces3D.UL, Pieces3D.F etc", ->
  expect(Pieces3D.UBL).to.be.undefined
  expect(Pieces3D.UL).to.be.undefined
  expect(Pieces3D.U).to.be.undefined

  Pieces3D.make_stickers({add: -> }) # Mocking a scene

  expect(Pieces3D.UBL).to.be.defined
  expect(Pieces3D.UL).to.be.defined
  expect(Pieces3D.U).to.be.defined

  expect(Pieces3D.BLU).to.be.undefined
  expect(Pieces3D.LU).to.be.undefined

