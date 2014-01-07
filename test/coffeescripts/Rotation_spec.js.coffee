#= require three.min
#= require roofpig/Rotation

describe "Rotation", ->
  describe "#_parse_code", ->
    it "parses all code variations", ->
      expect(Rotation._parse_code("U>")).to.have.members([Side.U, 1])
      expect(Rotation._parse_code("L>>")).to.have.members([Side.L, 2])
      expect(Rotation._parse_code("L<<") ).to.have.members([Side.L,-2])
      expect(Rotation._parse_code("D<")).to.have.members([Side.D,-1])

  describe "#constructor", ->
    it "set the right attributes", ->
      u1 = new Rotation("U>")
      expect(u1.side).to.equal(Side.U)
      expect(u1.turns).to.equal(1)
      expect(u1.turn_time).to.equal(240)

      u2 = new Rotation("U>>")
      expect(u2.side).to.equal(Side.U)
      expect(u2.turns).to.equal(2)
      expect(u2.turn_time).to.equal(360)

      u3 = new Rotation("U<")
      expect(u3.side).to.equal(Side.U)
      expect(u3.turns).to.equal(-1)
      expect(u3.turn_time).to.equal(240)

      uz = new Rotation("U<<")
      expect(uz.side).to.equal(Side.U)
      expect(uz.turns).to.equal(-2)
      expect(uz.turn_time).to.equal(360)

  it "#standard_text", ->
    expect(new Rotation("U>").standard_text()).to.equal('')

  it "#count", ->
    expect(new Rotation("U>>").count()).to.equal(0)
