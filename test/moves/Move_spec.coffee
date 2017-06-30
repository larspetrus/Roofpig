#= require three.min
#= require Move

describe "Move", ->
  describe "#parse_code", ->
    it "parses all code variations", ->
      expect(Move.parse_code("U1")).to.have.members([Layer.U, 1, false])
      expect(Move.parse_code("B") ).to.have.members([Layer.B, 1, false])

      expect(Move.parse_code("L2")).to.have.members([Layer.L, 2, false])
      expect(Move.parse_code("L²")).to.have.members([Layer.L, 2, false])

      expect(Move.parse_code("LZ") ).to.have.members([Layer.L,-2, false])
      expect(Move.parse_code("L2'")).to.have.members([Layer.L,-2, false])

      expect(Move.parse_code("D3")).to.have.members([Layer.D,-1, false])
      expect(Move.parse_code("F'")).to.have.members([Layer.F,-1, false])

      expect(-> Move.parse_code("Q2")).to.throw("Invalid Move code 'Q2'")
      expect(-> Move.parse_code("U0")).to.throw("Invalid Move code 'U0'")

      expect(Move.parse_code("M") ).to.have.members([Layer.M, 1, false])
      expect(Move.parse_code("E2")).to.have.members([Layer.E, 2, false])
      expect(Move.parse_code("S'")).to.have.members([Layer.S,-1, false])

      expect(Move.parse_code("U>")).to.have.members([Layer.U, 1, true])
      expect(Move.parse_code("L>>")).to.have.members([Layer.L, 2, true])
      expect(Move.parse_code("L<<") ).to.have.members([Layer.L,-2, true])
      expect(Move.parse_code("D<")).to.have.members([Layer.D,-1, true])

      expect(Move.parse_code("M>")).to.have.members([Layer.M, 1, true])
      expect(Move.parse_code("S>")).to.have.members([Layer.S, 1, true])
      expect(Move.parse_code("E>")).to.have.members([Layer.E, 1, true])

    it "throws exceptions for bad codes", ->
      expect(-> Move.parse_code("Q>")).to.throw("Invalid Move code 'Q>'")
      expect(-> Move.parse_code("U<>")).to.throw("Invalid Move code 'U<>'")

  describe "#turn_code", ->
    it "returns correct code", ->
      expect(Move.turn_code(1)).to.equal("")
      expect(Move.turn_code(2)).to.equal("2")
      expect(Move.turn_code(-1)).to.equal("'")
      expect(Move.turn_code(-2)).to.equal("Z")

      expect(Move.turn_code(1, true)).to.equal(">")
      expect(Move.turn_code(2, true)).to.equal(">>")
      expect(Move.turn_code(-1, true)).to.equal("<")
      expect(Move.turn_code(-2, true)).to.equal("<<")
