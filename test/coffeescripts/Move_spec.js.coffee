#= require three.min
#= require roofpig/Move

describe "Move#from_code", ->
  it "should make the right Move objects", ->
    expect(Move.from_code("U1").to_s(), "U1").to.equal(new Move(Side.U, 1).to_s())
    expect(Move.from_code("L2").to_s(), "L2").to.equal(new Move(Side.L, 2).to_s())
    expect(Move.from_code("D3").to_s(), "D3").to.equal(new Move(Side.D, 3).to_s())
    expect(Move.from_code("B") .to_s(), "B" ).to.equal(new Move(Side.B, 1).to_s())
    expect(Move.from_code("F'").to_s(), "F'").to.equal(new Move(Side.F, 3).to_s())

