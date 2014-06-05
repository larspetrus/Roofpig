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

  it "#standard_text", ->
    alg = new Alg("F R> U+D' L2 R' LZ D+D>")
    expect(alg.standard_text()).to.deep.equal(past:"", future: "F U+D' L2 R' L2 D")

    alg.next_move()
    expect(alg.standard_text()).to.deep.equal(past:"F", future: "U+D' L2 R' L2 D")

    alg.next_move()
    alg.next_move()
    expect(alg.standard_text()).to.deep.equal(past:"F U+D'", future: "L2 R' L2 D")

  it "handles 'shift'", ->
    expect(new Alg("shift> U F2 D' LZ").to_s()).to.equal("U L2 D' BZ")
    expect(new Alg("shift2 U F2 D' LZ").to_s()).to.equal("U B2 D' RZ")
    expect(new Alg("shift< U F2 D' LZ").to_s()).to.equal("U R2 D' FZ")
    expect(-> new Alg("shift< U F2 M").to_s()).to.throw("M, E, S, x, y or z can't be shifted.")
