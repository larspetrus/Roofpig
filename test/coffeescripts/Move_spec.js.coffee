#= require three.min
#= require roofpig/Move

describe "Move", ->
  describe "#_parse_code", ->
    it "parses all code variations", ->
      expect(Move._parse_code("U1")).to.have.members([Side.U, 1])
      expect(Move._parse_code("B") ).to.have.members([Side.B, 1])

      expect(Move._parse_code("L2")).to.have.members([Side.L, 2])
      expect(Move._parse_code("L²")).to.have.members([Side.L, 2])

      expect(Move._parse_code("LZ") ).to.have.members([Side.L,-2])
      expect(Move._parse_code("L2'")).to.have.members([Side.L,-2])

      expect(Move._parse_code("D3")).to.have.members([Side.D,-1])
      expect(Move._parse_code("F'")).to.have.members([Side.F,-1])

      expect(-> Move._parse_code("Q2")).to.throw("Invalid Move code 'Q2'")
      expect(-> Move._parse_code("U0")).to.throw("Invalid Move code 'U0'")

    it "Does slices etc", ->
      expect(Move._parse_code("M") ).to.have.members([Side.M, 1])
      expect(Move._parse_code("E2")).to.have.members([Side.E, 2])
      expect(Move._parse_code("S'")).to.have.members([Side.S,-1])


  describe "#constructor", ->
    it "set the right attributes", ->
      u1 = new Move("U")
      expect(u1.side).to.equal(Side.U)
      expect(u1.turns).to.equal(1)
      expect(u1.turn_time).to.equal(400)

      u2 = new Move("U2")
      expect(u2.side).to.equal(Side.U)
      expect(u2.turns).to.equal(2)
      expect(u2.turn_time).to.equal(600)

      u3 = new Move("U'")
      expect(u3.side).to.equal(Side.U)
      expect(u3.turns).to.equal(-1)
      expect(u3.turn_time).to.equal(400)

      uz = new Move("UZ")
      expect(uz.side).to.equal(Side.U)
      expect(uz.turns).to.equal(-2)
      expect(uz.turn_time).to.equal(600)

  it "#to_s", ->
    expect(new Move("U1").to_s()).to.equal("U")
    expect(new Move("U2").to_s()).to.equal("U2")
    expect(new Move("U3").to_s()).to.equal("U'")
    expect(new Move("UZ").to_s()).to.equal("UZ")

  it "#display_text", ->
    expect(new Move("U1").display_text()).to.equal("U")
    expect(new Move("U2").display_text()).to.equal("U2")
    expect(new Move("U3").display_text()).to.equal("U'")
    expect(new Move("UZ").display_text()).to.equal("U2")

  it "#count", ->
    expect(new Move("U2").count()).to.equal(1)
