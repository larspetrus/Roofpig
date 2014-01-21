#= require three.min
#= require roofpig/Side

describe "Side", ->
  it "#shift", ->
    expect(Side.F.shift('L', 1)).to.equal('U')
    expect(Side.F.shift('L', 2)).to.equal('R')
    expect(Side.F.shift('L', 3)).to.equal('D')

    expect(Side.F.shift('F', 1)).to.equal('F')
    expect(Side.F.shift('Q', 1)).to.be.null
    expect(-> Side.F.shift('F', 0)).to.throw(Error)

