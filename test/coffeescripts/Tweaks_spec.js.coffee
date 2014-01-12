#= require three.min
#= require roofpig/Tweaks

describe "Tweaks", ->
  it "#for_sticker", ->
    tweaks = new Tweaks("Uf:X Dl:x DL:RF")
    expect(tweaks.for_sticker('UF', 'U')).to.deep.equal(['X'])
    expect(tweaks.for_sticker('UF', 'F')).to.deep.equal([])
    expect(tweaks.for_sticker('DL', 'D')).to.deep.equal(['x', 'R'])
    expect(tweaks.for_sticker('DL', 'L')).to.deep.equal(['F'])
    expect(tweaks.for_sticker('UFR','U')).to.deep.equal([])
