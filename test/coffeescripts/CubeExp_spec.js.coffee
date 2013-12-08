#= require roofpig/CubeExp

describe "CubeExp", ->
  describe "stringthing", ->
    it "Passes through simple piece names", ->
      expect(new CubeExp("UFR").stringthing).to.equal(" UFR ")
      expect(new CubeExp("UFR FL").stringthing).to.equal(" UFR FL ")

    it "Expands wild cards", ->
      expect(new CubeExp("UFR*").stringthing).to.equal(" UFR UF UR FR U F R ")

      expect(new CubeExp("U*").stringthing).to.equal(" U UB UBL UBR UF UFL UFR UL UR ")
      expect(new CubeExp("F*").stringthing).to.equal(" DF DFL DFR F FL FR UF UFL UFR ")

      expect(new CubeExp("").stringthing).to.equal(" B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR ")
      expect(new CubeExp(null).stringthing).to.equal(" B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR ")

    it "handles permuted names", ->
      expect(new CubeExp("FRU").stringthing).to.equal(" UFR ")
      expect(new CubeExp("FUR LF").stringthing).to.equal(" UFR FL ")
      expect(new CubeExp("FRU*").stringthing).to.equal(" UFR UF UR FR U F R ")


  describe "#matches_sticker", ->
    it "doesn't have the substring bug", ->
      expect(new CubeExp(" UFR FR ").matches_sticker("UFR")).to.equal(true)
      expect(new CubeExp(" UFR FR ").matches_sticker("FR")).to.equal(true)
      expect(new CubeExp(" UFR FR ").matches_sticker("UF")).to.equal(false)
      expect(new CubeExp(" UFR FR ").matches_sticker("U")).to.equal(false)

    it "handles permuted piece names", ->
      expect(new CubeExp(" UFR FR ").matches_sticker("FRU")).to.equal(true)
      expect(new CubeExp(" UFR FR ").matches_sticker("URF")).to.equal(true)
      expect(new CubeExp(" UFR FR ").matches_sticker("RF")).to.equal(true)
      expect(new CubeExp(" UFR FR ").matches_sticker("UFFR")).to.equal(false)

