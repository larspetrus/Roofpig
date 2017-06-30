#= require three.min
#= require SingleMove

describe "SingleMove", ->

  describe "#constructor", ->
    it "sets the right attributes", ->
      time = 200

      move_should_be(new SingleMove("U"),  Layer.U,  1, false, 2*time)
      move_should_be(new SingleMove("U2"), Layer.U,  2, false, 3*time)
      move_should_be(new SingleMove("U'"), Layer.U, -1, false, 2*time)
      move_should_be(new SingleMove("UZ"), Layer.U, -2, false, 3*time)

      move_should_be(new SingleMove("U>"), Layer.U, 1,  true, 2*time)
      move_should_be(new SingleMove("U>>"),Layer.U, 2,  true, 3*time)
      move_should_be(new SingleMove("U<"), Layer.U, -1, true, 2*time)
      move_should_be(new SingleMove("U<<"),Layer.U, -2, true, 3*time)

  it "#to_s", ->
    expect(new SingleMove("U1").to_s()).to.equal("U")
    expect(new SingleMove("U2").to_s()).to.equal("U2")
    expect(new SingleMove("U3").to_s()).to.equal("U'")
    expect(new SingleMove("UZ").to_s()).to.equal("UZ")

  it "#display_text", ->
    expect(new SingleMove("U1").display_text(Zcode: "2")).to.equal("U")
    expect(new SingleMove("U2").display_text(Zcode: "2")).to.equal("U2")
    expect(new SingleMove("U3").display_text(Zcode: "2")).to.equal("U'")
    expect(new SingleMove("UZ").display_text(Zcode: "2")).to.equal("U2")
    expect(new SingleMove("UZ").display_text(Zcode: "Z")).to.equal("UZ")

    expect(new SingleMove("U>").display_text({})).to.equal('')
    expect(new SingleMove("U>").display_text({rotations: true})).to.equal('U>')

  it "#count", ->
    expect(new SingleMove("U2").count()).to.equal(1)

    expect(new SingleMove("U>>").count(false)).to.equal(0)
    expect(new SingleMove("U>>").count(true)).to.equal(1)

  it "#track_pov", ->
    map = PovTracker.start_map()

    new SingleMove("U").track_pov(map)
    expect(map).to.deep.equal(PovTracker.start_map())

    new SingleMove("S").track_pov(map)
    expect(map).to.deep.equal(B: "B", D: "L", F: "F", L: "U", R: "D", U: "R")

  it "#as_brdflu", ->
    expect(new SingleMove("U2").as_brdflu()).to.equal("U2")
    expect(new SingleMove("M").as_brdflu()).to.equal("L' R")
    expect(new SingleMove("M2").as_brdflu()).to.equal("L2 R2")
    expect(new SingleMove("M'").as_brdflu()).to.equal("L R'")
    expect(new SingleMove("E").as_brdflu()).to.equal("D' U")
    expect(new SingleMove("S").as_brdflu()).to.equal("B F'")

  move_should_be = (move, layer, turns, is_rotation, turn_time) ->
    expect(move.layer, move.to_s()).to.equal(layer)
    expect(move.turns, move.to_s()).to.equal(turns)
    expect(move.is_rotation, move.to_s()).to.equal(is_rotation)
    expect(move.turn_time, move.to_s()).to.equal(turn_time)
