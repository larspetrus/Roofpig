#= require three.min
#= require roofpig/Alg

mock_dom_handler = {
  alg_changed: ->
  init_alg_text: ->
}

describe "Alg", ->
  describe "#constructor", ->
    it "reads move strings", ->
      expect(new Alg("U F2 D' LZ", mock_dom_handler).to_s()).to.equal("U F2 D' LZ")
      expect(new Alg(" U F2  D' LZ  ", mock_dom_handler).to_s()).to.equal("U F2 D' LZ")
      expect(new Alg("F D+U'", mock_dom_handler).to_s()).to.equal("F (D U')")

    it "fails empty alg", ->
      expect(-> new Alg("", mock_dom_handler)).to.throw("Invalid alg: ''")

  it "keeps track of moves", ->
    alg = new Alg('F D', mock_dom_handler)

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