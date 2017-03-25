#= require three.min
#= require Move

describe "Move", ->
  describe "#_parse_code", ->
    it "parses all code variations", ->
      expect(Move._parse_code("U1")).to.have.members([Layer.U, 1, false])
      expect(Move._parse_code("B") ).to.have.members([Layer.B, 1, false])

      expect(Move._parse_code("L2")).to.have.members([Layer.L, 2, false])
      expect(Move._parse_code("L²")).to.have.members([Layer.L, 2, false])

      expect(Move._parse_code("LZ") ).to.have.members([Layer.L,-2, false])
      expect(Move._parse_code("L2'")).to.have.members([Layer.L,-2, false])

      expect(Move._parse_code("D3")).to.have.members([Layer.D,-1, false])
      expect(Move._parse_code("F'")).to.have.members([Layer.F,-1, false])

      expect(-> Move._parse_code("Q2")).to.throw("Invalid Move code 'Q2'")
      expect(-> Move._parse_code("U0")).to.throw("Invalid Move code 'U0'")

      expect(Move._parse_code("M") ).to.have.members([Layer.M, 1, false])
      expect(Move._parse_code("E2")).to.have.members([Layer.E, 2, false])
      expect(Move._parse_code("S'")).to.have.members([Layer.S,-1, false])

      expect(Move._parse_code("U>")).to.have.members([Layer.U, 1, true])
      expect(Move._parse_code("L>>")).to.have.members([Layer.L, 2, true])
      expect(Move._parse_code("L<<") ).to.have.members([Layer.L,-2, true])
      expect(Move._parse_code("D<")).to.have.members([Layer.D,-1, true])

      expect(-> Move._parse_code("Q>")).to.throw("Invalid Move code 'Q>'")
      expect(-> Move._parse_code("U<>")).to.throw("Invalid Move code 'U<>'")

      expect(Move._parse_code("M>")).to.have.members([Layer.M, 1, true])
      expect(Move._parse_code("S>")).to.have.members([Layer.S, 1, true])
      expect(Move._parse_code("E>")).to.have.members([Layer.E, 1, true])

  describe "#constructor", ->
    it "sets the right attributes", ->
      time = 200

      move_should_be(new Move("U"),  Layer.U,  1, false, 2*time)
      move_should_be(new Move("U2"), Layer.U,  2, false, 3*time)
      move_should_be(new Move("U'"), Layer.U, -1, false, 2*time)
      move_should_be(new Move("UZ"), Layer.U, -2, false, 3*time)

      move_should_be(new Move("U>"), Layer.U, 1,  true, 2*time)
      move_should_be(new Move("U>>"),Layer.U, 2,  true, 3*time)
      move_should_be(new Move("U<"), Layer.U, -1, true, 2*time)
      move_should_be(new Move("U<<"),Layer.U, -2, true, 3*time)

  it "#to_s", ->
    expect(new Move("U1").to_s()).to.equal("U")
    expect(new Move("U2").to_s()).to.equal("U2")
    expect(new Move("U3").to_s()).to.equal("U'")
    expect(new Move("UZ").to_s()).to.equal("UZ")

  it "#display_text", ->
    expect(new Move("U1").display_text(Zcode: "2")).to.equal("U")
    expect(new Move("U2").display_text(Zcode: "2")).to.equal("U2")
    expect(new Move("U3").display_text(Zcode: "2")).to.equal("U'")
    expect(new Move("UZ").display_text(Zcode: "2")).to.equal("U2")
    expect(new Move("UZ").display_text(Zcode: "Z")).to.equal("UZ")

    expect(new Move("U>").display_text({})).to.equal('')
    expect(new Move("U>").display_text({rotations: true})).to.equal('U>')

  it "#count", ->
    expect(new Move("U2").count()).to.equal(1)

    expect(new Move("U>>").count(false)).to.equal(0)
    expect(new Move("U>>").count(true)).to.equal(1)

  it "#track_pov", ->
    map = Pov.start_map()

    new Move("U").track_pov(map)
    expect(map).to.deep.equal(Pov.start_map())

    new Move("S").track_pov(map)
    expect(map).to.deep.equal(B: "B", D: "L", F: "F", L: "U", R: "D", U: "R")

  it "#as_brdflu", ->
    expect(new Move("U2").as_brdflu()).to.equal("U2")
    expect(new Move("M").as_brdflu()).to.equal("L' R")
    expect(new Move("M2").as_brdflu()).to.equal("L2 R2")
    expect(new Move("M'").as_brdflu()).to.equal("L R'")
    expect(new Move("E").as_brdflu()).to.equal("D' U")
    expect(new Move("S").as_brdflu()).to.equal("B F'")

  move_should_be = (move, layer, turns, is_rotation, turn_time) ->
    expect(move.layer, move.to_s()).to.equal(layer)
    expect(move.turns, move.to_s()).to.equal(turns)
    expect(move.is_rotation, move.to_s()).to.equal(is_rotation)
    expect(move.turn_time, move.to_s()).to.equal(turn_time)
