#= require roofpig/Alg

mock_button_row = { alg_changed: -> }
mock_pieces = {
  on: ->
  move: ->
}

describe "Alg#constructor", ->
  it "reads a move string", ->
    expect(new Alg("U F2 D''", mock_button_row).to_s()).to.equal("U1 F2 D3")

  it "keeps track of moves", ->
    alg = new Alg('F D', mock_button_row, mock_pieces)

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

