#= require three.min
#= require roofpig/Colors

describe "Colors", ->
  describe "of", ->
    it "has default values", ->
      colors = new Colors("", "")
      expect(colors.of(Side.R)).to.equal('#0d0')
      expect(colors.of(Side.L)).to.equal('blue')
      expect(colors.of(Side.F)).to.equal('red')
      expect(colors.of(Side.B)).to.equal('orange')
      expect(colors.of(Side.U)).to.equal('yellow')
      expect(colors.of(Side.D)).to.equal('#eee'  )
      expect(colors.of('solved')).to.equal('#666')
      expect(colors.of('ignored')).to.equal('#aaa')

      expect(-> colors.of('UNKNOWN')).to.throw(Error)

  describe "#at", ->
    it "is colored by default", ->
      colors = new Colors("", "")
      expect(colors.at('UFR', Side.F).color).to.equal(colors.of(Side.F))
      expect(colors.at('DB', Side.B).color).to.equal(colors.of(Side.B))
      expect(colors.at('L', Side.L).color).to.equal(colors.of(Side.L))

    it "colors only specified stickers", ->
      colors = new Colors("U*", "")
      expect(colors.at('UFR', Side.F).color).to.equal(colors.of(Side.F))
      expect(colors.at('DB', Side.B).color).to.equal(colors.of('ignored'))
      expect(colors.at('L', Side.L).color).to.equal(colors.of('ignored'))

    it "solved overrides colored", ->
      colors = new Colors("U*", "F*")
      expect(colors.at('UFR', Side.F).color).to.equal(colors.of('solved'))
      expect(colors.at('UR', Side.U).color).to.equal(colors.of(Side.U))
      expect(colors.at('F', Side.F).color).to.equal(colors.of('solved'))
      expect(colors.at('L', Side.L).color).to.equal(colors.of('ignored'))

  describe "_expand", ->
    it "Passes through the simple", ->
      expect(Colors._expand("UFR")).to. equal(" UFR ")
      expect(Colors._expand("UFR FL")).to. equal(" UFR FL ")

    it "Expands wild cards", ->
      expect(Colors._expand("UFR*")).to. equal(" UFR UF UR FR U F R ")

      expect(Colors._expand("U*")).to. equal(" U UB UBL UBR UF UFL UFR UL UR ")
      expect(Colors._expand("F*")).to. equal(" DF DFL DFR F FL FR UF UFL UFR ")

      expect(Colors._expand("")).to. equal(" B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR ")
      expect(Colors._expand(null)).to. equal(" B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR ")

  describe "#_selected_sticker", ->
    it "triggers on only full codes", ->
      expect(Colors._selected_sticker(" UFR FR ", "UFR")).to.equal(true)
      expect(Colors._selected_sticker(" UFR FR ", "FR")).to.equal(true)
      expect(Colors._selected_sticker(" UFR FR ", "UF")).to.equal(false)
      expect(Colors._selected_sticker(" UFR FR ", "U")).to.equal(false)
