#= require three.min
#= require roofpig/Rotation

describe "Rotation", ->
  describe "#_parse_code", ->
    it "parses all code variations", ->
      expect(Rotation._parse_code("U>")).to.have.members([Layer.U, 1])
      expect(Rotation._parse_code("L>>")).to.have.members([Layer.L, 2])
      expect(Rotation._parse_code("L<<") ).to.have.members([Layer.L,-2])
      expect(Rotation._parse_code("D<")).to.have.members([Layer.D,-1])

      expect(-> Rotation._parse_code("Q>")).to.throw("Invalid Rotation code 'Q>'")
      expect(-> Rotation._parse_code("U<>")).to.throw("Invalid Rotation code 'U<>'")

    it "does no slices etc", ->
      expect(-> Rotation._parse_code("M>")).to.throw("Invalid Rotation code 'M>'")
      expect(-> Rotation._parse_code("S>")).to.throw("Invalid Rotation code 'S>'")
      expect(-> Rotation._parse_code("E>")).to.throw("Invalid Rotation code 'E>'")


  describe "#constructor", ->
    it "set the right attributes", ->
      time = 200

      u1 = new Rotation("U>")
      expect(u1.layer).to.equal(Layer.U)
      expect(u1.turns).to.equal(1)
      expect(u1.turn_time).to.equal(2*time)

      u2 = new Rotation("U>>")
      expect(u2.layer).to.equal(Layer.U)
      expect(u2.turns).to.equal(2)
      expect(u2.turn_time).to.equal(3*time)

      u3 = new Rotation("U<")
      expect(u3.layer).to.equal(Layer.U)
      expect(u3.turns).to.equal(-1)
      expect(u3.turn_time).to.equal(2*time)

      uz = new Rotation("U<<")
      expect(uz.layer).to.equal(Layer.U)
      expect(uz.turns).to.equal(-2)
      expect(uz.turn_time).to.equal(3*time)

  it "#display_text", ->
    expect(new Rotation("U>").display_text({})).to.equal('')
    expect(new Rotation("U>").display_text({rotations: true})).to.equal('U>')

  it "#count", ->
    expect(new Rotation("U>>").count(false)).to.equal(0)
    expect(new Rotation("U>>").count(true)).to.equal(1)
