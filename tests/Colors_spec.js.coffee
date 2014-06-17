#= require three.min
#= require roofpig/Colors
#= require ../../app/assets/javascripts/roofpig/Layer.js.coffee

describe "Colors", ->
  describe "of", ->
    it "has default values", ->
      colors = new Colors("", "", "")
      expect(colors.of(Layer.R)).to.equal('#0d0')
      expect(colors.of(Layer.L)).to.equal('#07f')
      expect(colors.of(Layer.F)).to.equal('red')
      expect(colors.of(Layer.B)).to.equal('orange')
      expect(colors.of(Layer.U)).to.equal('yellow')
      expect(colors.of(Layer.D)).to.equal('#eee'  )
      expect(colors.of('solved')).to.equal('#444')
      expect(colors.of('ignored')).to.equal('#888')

      expect(colors.of('L')).to.equal(colors.of(Layer.L))
      expect(colors.of('F')).to.equal(colors.of(Layer.F))

      expect(-> colors.of('UNKNOWN')).to.throw(Error)
    
    it "can change colors", ->
      colors = new Colors("", "", "", "R:o L:#abc solved:r c:#123")

      expect(colors.of(Layer.R)).to.equal('orange')
      expect(colors.of(Layer.L)).to.equal('#abc')
      expect(colors.of('solved')).to.equal('red')
      expect(colors.of('cube')).to.equal('#123')

      expect(colors.of(Layer.U)).to.equal('yellow')
      expect(colors.of(Layer.D)).to.equal('#eee'  )

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

    it "last tweak color wins", ->
      colors = new Colors("*", "", "R:U* L:F*")
      expect(colors.to_draw('D', 'D')).to.deep.equal(color: colors.of('D'), hovers: true) #untweaked
      expect(colors.to_draw('U', 'U')).to.deep.equal(color: colors.of('R'), hovers: true) #tweaked
      expect(colors.to_draw('F', 'F')).to.deep.equal(color: colors.of('L'), hovers: true) #tweaked
      expect(colors.to_draw('UF','U')).to.deep.equal(color: colors.of('L'), hovers: true) #double tweaked

    describe "tweaks", ->
      it "sets X and colors", ->
        colors = new Colors("", "*", ".Xx:uFR  D.L:UfR")

        expect(colors.to_draw('UFR', 'U')).to.deep.equal(color: colors.of('D'), hovers: true)
        expect(colors.to_draw('UFR', 'F')).to.deep.equal(color: colors.of('solved'), hovers: true, x_color: 'black')
        expect(colors.to_draw('UFR', 'R')).to.deep.equal(color: colors.of('L'), hovers: true, x_color: 'white')

      it "overrides colored and solved", ->
        colors = new Colors("U*", "D*", "L:U  R:D")

        expect(colors.to_draw('U', Layer.U).color).to.equal(colors.of(Layer.L))
        expect(colors.to_draw('D', Layer.D).color).to.equal(colors.of(Layer.R))


