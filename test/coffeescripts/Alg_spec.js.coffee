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

    it "fails empty alg", ->
      expect(-> new Alg("", mock_dom_handler)).to.throw("Invalid alg: ''")

  it "keeps track of moves", ->
    alg = new Alg('F D', mock_dom_handler)

    expect(alg.at_start(), '0s').to.equal(true)
    expect(alg.at_end(), '0e').to.equal(false)

    alg.next_move()
    expect(alg.at_start(), '1s').to.equal(false)
    expect(alg.at_end(), '1e').to.equal(false)

    alg.next_move()
    expect(alg.at_start(), '2s').to.equal(false)
    expect(alg.at_end(), '2e').to.equal(true)

    alg.next_move()
    expect(alg.at_start(), '3s').to.equal(false)
    expect(alg.at_end(), '3e').to.equal(true)

  it "doesn't need a DomHandler", ->
    alone_alg = new Alg("U F2 D' LZ", null)
    expect(alone_alg.to_s()).to.equal("U F2 D' LZ")