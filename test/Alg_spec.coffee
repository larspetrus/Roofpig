#= require three.min
#= require Alg
#= require Config

describe "Alg", ->
  describe "#constructor", ->
    it "reads move strings", ->
      expect(new Alg("U F2 D' LZ").to_s()).to.equal("U F2 D' LZ")
      expect(new Alg(" U F2  D' LZ  ").to_s()).to.equal("U F2 D' LZ")
      expect(new Alg("F D+U'").to_s()).to.equal("F (D U')")

    it "handles empty alg", ->
      expect(new Alg("").at_start()).to.be.true
      expect(new Alg("").at_end()).to.be.true

  it "keeps track of moves", ->
    alg = new Alg('F D')

    expect(alg.at_start()).to.be.true
    expect(alg.at_end()).to.be.false

    alg.next_move()
    expect(alg.at_start()).to.be.false
    expect(alg.at_end()).to.be.false

    alg.next_move()
    expect(alg.at_start()).to.be.false
    expect(alg.at_end()).to.be.true

    alg.next_move()
    expect(alg.at_start()).to.be.false
    expect(alg.at_end()).to.be.true

  it "doesn't need a Dom", ->
    alone_alg = new Alg("U F2 D' LZ", null)
    expect(alone_alg.to_s()).to.equal("U F2 D' LZ")

  it "builds the right Move objects", ->
    move_should_be(new Alg("F2").moves[0], Layer.F, 2)

    move_should_be(new Alg("R<").moves[0], Layer.R, -1, true)
    
    compound = new Alg("L'+F>>").moves[0]
    expect(compound instanceof CompositeMove).to.be.true
    expect(compound.moves.length).to.equal(2)
    move_should_be(compound.moves[0], Layer.L, -1)
    move_should_be(compound.moves[1], Layer.F, 2, true)

    the_x = new Alg("x").moves[0]
    expect(the_x instanceof CompositeMove).to.be.true
    expect(the_x.count()).to.equal(1)
    expect(the_x.to_s()).to.equal("(R M' L')")
    expect(the_x.moves.length).to.equal(3)
    move_should_be(the_x.moves[0], Layer.R, 1)
    move_should_be(the_x.moves[1], Layer.M, -1)
    move_should_be(the_x.moves[2], Layer.L, -1)

    wide_r = new Alg("Uw2").moves[0]
    expect(wide_r instanceof CompositeMove).to.be.true
    expect(wide_r.count()).to.equal(1)
    expect(wide_r.to_s()).to.equal("(U2 EZ)")
    expect(wide_r.moves.length).to.equal(2)
    move_should_be(wide_r.moves[0], Layer.U, 2)
    move_should_be(wide_r.moves[1], Layer.E, -2)

  describe "#_count_text", ->
    world = null

    it "ignoring rotations", ->
      alg = new Alg("F L> D'+U R+R>", world, new Config("").algdisplay)
      expect(alg._count_text()).to.equal('0/4')

      alg.next_move()
      expect(alg._count_text()).to.equal('1/4')

      alg.next_move()
      expect(alg._count_text()).to.equal('1/4')

      alg.next_move()
      expect(alg._count_text()).to.equal('3/4')

      alg.next_move()
      expect(alg._count_text()).to.equal('4/4')

    it "counting rotations", ->
      alg = new Alg("F L> D'+U R+R>", world, new Config("algdisplay=rotations").algdisplay)
      expect(alg._count_text()).to.equal('0/6')

      alg.next_move()
      expect(alg._count_text()).to.equal('1/6')

      alg.next_move()
      expect(alg._count_text()).to.equal('2/6')

      alg.next_move()
      expect(alg._count_text()).to.equal('4/6')

      alg.next_move()
      expect(alg._count_text()).to.equal('6/6')

  describe "#display_text", ->
    world = null

    it "separates past and future moves", ->
      alg = new Alg("F R> U+D' L2 R' LZ D+D>", world, new Config("").algdisplay)
      expect(alg.display_text()).to.deep.equal(past:"", future: "F U+D' L2 R' L2 D")

      alg.next_move()
      expect(alg.display_text()).to.deep.equal(past:"F", future: "U+D' L2 R' L2 D")

      alg.next_move()
      alg.next_move()
      expect(alg.display_text()).to.deep.equal(past:"F U+D'", future: "L2 R' L2 D")

    it "uses algdisplay", ->
      alg = new Alg("F R> U2+D' F<< LZ D+D>", world, new Config("algdisplay=Z").algdisplay)
      expect(alg.display_text().future).to.equal("F U2+D' LZ D")

      alg = new Alg("F R> U2+D' F<< LZ D+D>", world, new Config("algdisplay=2p").algdisplay)
      expect(alg.display_text().future).to.equal("F U2+D' L2' D")

      alg = new Alg("F R> U2+D' F<< LZ D+D>", world, new Config("algdisplay=fancy2s").algdisplay)
      expect(alg.display_text().future).to.equal("F U²+D' L² D")

      alg = new Alg("F R> U2+D' F<< LZ D+D>", world, new Config("algdisplay=rotations").algdisplay)
      expect(alg.display_text().future).to.equal("F R> U2+D' F<< L2 D+D>")

  it "#_side_drift", ->
    world = null
    expect(new Alg("F", world, "")._side_drift()).to.deep.equal(U: 'U', D: 'D', L: 'L', R: 'R', F: 'F', B: 'B')
    expect(new Alg("M", world, "")._side_drift()).to.deep.equal(U: 'B', D: 'F', L: 'L', R: 'R', F: 'U', B: 'D')
    expect(new Alg("M z", world, "")._side_drift()).to.deep.equal(U: 'L', D: 'R', L: 'F', R: 'B', F: 'U', B: 'D')
    expect(new Alg("MZ", world, "")._side_drift()).to.deep.equal(U: 'D', D: 'U', L: 'L', R: 'R', F: 'B', B: 'F')

  it "@side_drift", ->
    expect(Alg.side_drift("F")).to.deep.equal(U: 'U', D: 'D', L: 'L', R: 'R', F: 'F', B: 'B')
    expect(Alg.side_drift("M")).to.deep.equal(U: 'B', D: 'F', L: 'L', R: 'R', F: 'U', B: 'D')

  move_should_be = (move, layer, turns, is_rotation = false) ->
    expect(move.layer, move.to_s()).to.equal(layer)
    expect(move.turns, move.to_s()).to.equal(turns)
    expect(move.is_rotation, move.to_s()).to.equal(is_rotation)
