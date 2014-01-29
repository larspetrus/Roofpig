#= require three.min
#= require roofpig/Colors
#= require roofpig/Side

describe "Colors", ->
  describe "of", ->
    it "has default values", ->
      colors = new Colors("", "", "")
      expect(colors.of(Side.R)).to.equal('#0d0')
      expect(colors.of(Side.L)).to.equal('#07f')
      expect(colors.of(Side.F)).to.equal('red')
      expect(colors.of(Side.B)).to.equal('orange')
      expect(colors.of(Side.U)).to.equal('yellow')
      expect(colors.of(Side.D)).to.equal('#eee'  )
      expect(colors.of('solved')).to.equal('#444')
      expect(colors.of('ignored')).to.equal('#888')

      expect(colors.of('L')).to.equal(colors.of(Side.L))
      expect(colors.of('F')).to.equal(colors.of(Side.F))

      expect(-> colors.of('UNKNOWN')).to.throw(Error)
    
    it "can change colors", ->
      colors = new Colors("", "", "", "R:O L:#abc solved:R p:#123")

      expect(colors.of(Side.R)).to.equal('orange')
      expect(colors.of(Side.L)).to.equal('#abc')
      expect(colors.of('solved')).to.equal('red')
      expect(colors.of('plastic')).to.equal('#123')

      expect(colors.of(Side.U)).to.equal('yellow')
      expect(colors.of(Side.D)).to.equal('#eee'  )

  describe "#to_draw", ->
    it "is colored by default", ->
      colors = new Colors("", "")
      expect(colors.to_draw('UFR','F')).to.deep.equal(color: colors.of('F'), hovers: true)
      expect(colors.to_draw('DB', 'B')).to.deep.equal(color: colors.of('B'), hovers: true)
      expect(colors.to_draw('L',  'L')).to.deep.equal(color: colors.of('L'), hovers: true)

    it "colors only specified stickers", ->
      colors = new Colors("U*", "")
      expect(colors.to_draw('UFR','F')).to.deep.equal(color: colors.of('F'), hovers: true)
      expect(colors.to_draw('DB', 'B')).to.deep.equal(color: colors.of('ignored'), hovers: false)
      expect(colors.to_draw('L',  'L')).to.deep.equal(color: colors.of('ignored'), hovers: false)

    it "solved overrides colored", ->
      colors = new Colors("U*", "F*")
      expect(colors.to_draw('UFR','F')).to.deep.equal(color: colors.of('solved'), hovers: false)
      expect(colors.to_draw('UR', 'U')).to.deep.equal(color: colors.of('U'), hovers: true)
      expect(colors.to_draw('F',  'F')).to.deep.equal(color: colors.of('solved'), hovers: false)
      expect(colors.to_draw('L',  'L')).to.deep.equal(color: colors.of('ignored'), hovers: false)

    describe "tweaks", ->
      it "sets X and colors", ->
        colors = new Colors("", "*", "uFR:.Xx  UfR:D.L")

        expect(colors.to_draw('UFR', 'U')).to.deep.equal(color: colors.of('D'), hovers: true)
        expect(colors.to_draw('UFR', 'F')).to.deep.equal(color: colors.of('solved'), hovers: true, x_color: 'black')
        expect(colors.to_draw('UFR', 'R')).to.deep.equal(color: colors.of('L'), hovers: true, x_color: 'white')

      it "overrides colored and solved", ->
        colors = new Colors("U*", "D*", "U:L  D:R")

        expect(colors.to_draw('U', Side.U).color).to.equal(colors.of(Side.L))
        expect(colors.to_draw('D', Side.D).color).to.equal(colors.of(Side.R))


