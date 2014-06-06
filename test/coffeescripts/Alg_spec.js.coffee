#= require three.min
#= require roofpig/Alg

describe "Alg", ->
  describe "#constructor", ->
    it "reads move strings", ->
      expect(new Alg("U F2 D' LZ").to_s()).to.equal("U F2 D' LZ")
      expect(new Alg(" U F2  D' LZ  ").to_s()).to.equal("U F2 D' LZ")
      expect(new Alg("F D+U'").to_s()).to.equal("F (D U')")

    it "fails empty alg", ->
      expect(-> new Alg("")).to.throw("Invalid alg: ''")

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

  it "doesn't need a DomHandler", ->
    alone_alg = new Alg("U F2 D' LZ", null)
    expect(alone_alg.to_s()).to.equal("U F2 D' LZ")

  it "builds the right action objects", ->
    action_should_be(new Alg("F2").actions[0], Move, Side.F, 2)

    action_should_be(new Alg("R<").actions[0], Rotation, Side.R, -1)
    
    compound = new Alg("L'+F>>").actions[0]
    expect(compound instanceof CompositeMove).to.be.true
    expect(compound.actions.length).to.equal(2)
    action_should_be(compound.actions[0], Move, Side.L, -1)
    action_should_be(compound.actions[1], Rotation, Side.F, 2)

    the_x = new Alg("x").actions[0]
    expect(the_x instanceof CompositeMove).to.be.true
    expect(the_x.display_text()).to.equal("x")
    expect(the_x.count()).to.equal(1)
    expect(the_x.to_s()).to.equal("(R M' L')")
    expect(the_x.actions.length).to.equal(3)
    action_should_be(the_x.actions[0], Move, Side.R, 1)
    action_should_be(the_x.actions[1], Move, Side.M, -1)
    action_should_be(the_x.actions[2], Move, Side.L, -1)

  it "_count_text", ->
    alg = new Alg("F L> D'+U R+R>")
    expect(alg._count_text()).to.equal('0/4')

    alg.next_move()
    expect(alg._count_text()).to.equal('1/4')

    alg.next_move()
    expect(alg._count_text()).to.equal('1/4')

    alg.next_move()
    expect(alg._count_text()).to.equal('3/4')

    alg.next_move()
    expect(alg._count_text()).to.equal('4/4')

  it "#display_text", ->
    alg = new Alg("F R> U+D' L2 R' LZ D+D>")
    expect(alg.display_text()).to.deep.equal(past:"", future: "F U+D' L2 R' L2 D")

    alg.next_move()
    expect(alg.display_text()).to.deep.equal(past:"F", future: "U+D' L2 R' L2 D")

    alg.next_move()
    alg.next_move()
    expect(alg.display_text()).to.deep.equal(past:"F U+D'", future: "L2 R' L2 D")

  it "handles 'shift'", ->
    expect(new Alg("shift> U F2 D' LZ").to_s()).to.equal("U L2 D' BZ")
    expect(new Alg("shift2 U F2 D' LZ").to_s()).to.equal("U B2 D' RZ")
    expect(new Alg("shift< U F2 D' LZ").to_s()).to.equal("U R2 D' FZ")
    expect(-> new Alg("shift< U F2 M").to_s()).to.throw("M, E, S, x, y or z can't be shifted.")


action_should_be = (action, klass, side, turns) ->
  expect(action instanceof klass, action.to_s()).to.be.true
  expect(action.side, action.to_s()).to.equal(side)
  expect(action.turns, action.to_s()).to.equal(turns)
