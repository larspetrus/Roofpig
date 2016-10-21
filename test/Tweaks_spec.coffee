#= require three.min
#= require Tweaks

describe "Tweaks", ->
  it "#for_sticker", ->
    tweaks = new Tweaks("X:Uf x:Dl RF:DL")

    expect(tweaks.for_sticker('UF', 'U'), 1).to.deep.equal(['X'])
    expect(tweaks.for_sticker('UF', 'F'), 2).to.deep.equal([])
    expect(tweaks.for_sticker('DL', 'D'), 3).to.deep.equal(['x', 'R'])
    expect(tweaks.for_sticker('DL', 'L'), 4).to.deep.equal(['F'])
    expect(tweaks.for_sticker('UFR','U'), 5).to.deep.equal([])

  it "handles syntax", ->
    tweaks = new Tweaks("Uf:X    DL:RF")
    tweaks = new Tweaks("XYZ")

  it "handles Cubexps", ->
    tweaks = new Tweaks("X:DBL-")
    expect(tweaks.for_sticker('UFR', 'R')).to.deep.equal(['X'])
    expect(tweaks.for_sticker('UF',  'U')).to.deep.equal(['X'])
    expect(tweaks.for_sticker('F',   'F')).to.deep.equal(['X'])
    expect(tweaks.for_sticker('DFR', 'F')).to.deep.equal([])
    expect(tweaks.for_sticker('D',    'D')).to.deep.equal([])

#  it "'last wins'", ->
#    tweaks = new Tweaks("F:U* R:L*")
