#= require roofpig/CubeExp

exp = (e) -> new CubeExp(e)

describe "CubeExp", ->
  describe "matches", ->
    it "Passes through simple piece names", ->
      expect(JSON.stringify(exp("UFR").matches)).to.equal(JSON.stringify(exp("UFR").matches))
      expect(exp("UFR").matches).to.deep.equal(exp("UFR").matches)
      expect(exp("UFR FL").matches).to.deep.equal(exp("UFR FL").matches)

    it "Expands wild cards", ->
      expect(exp("UFR*").matches).to.deep.equal(exp("UFR UF UR FR U F R").matches)

      expect(exp("U*").matches).to.deep.equal(exp("U UB UBL UBR UF UFL UFR UL UR").matches)
      expect(exp("F*").matches).to.deep.equal(exp("DF DFL DFR F FL FR UF UFL UFR").matches)

      expect(exp("").matches).to.deep.equal(exp("B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR").matches)
      expect(exp(null).matches).to.deep.equal(exp("B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR").matches)

    it "handles permuted names", ->
      expect(exp("FRU").matches).to.deep.equal(exp("UFR").matches)
      expect(exp("FUR LF").matches).to.deep.equal(exp("UFR FL").matches)
      expect(exp("FRU*").matches).to.deep.equal(exp("UFR UF UR FR U F R").matches)


  describe "#matches_sticker", ->
    it "doesn't have the substring bug", ->
      ufr_fr = exp("UFR FR")
      expect(ufr_fr.matches_sticker("UFR", "U")).to.be.true
      expect(ufr_fr.matches_sticker("FR", "R")).to.be.true
      expect(ufr_fr.matches_sticker("UF", "F")).to.be.false
      expect(ufr_fr.matches_sticker("U", "U")).to.be.false

    it "individual stickers", ->
      sample = exp("dFL dFr Bu")
      expect(sample.matches_sticker("DFL", "D"), 1).to.be.false
      expect(sample.matches_sticker("DFL", "F"), 2).to.be.true
      expect(sample.matches_sticker("DFL", "L"), 3).to.be.true

      expect(sample.matches_sticker("DFR", "D"), 4).to.be.false
      expect(sample.matches_sticker("DFR", "F"), 5).to.be.true
      expect(sample.matches_sticker("DFR", "R"), 6).to.be.false

      expect(sample.matches_sticker("BU", "B"), 7).to.be.true
      expect(sample.matches_sticker("BU", "U"), 8).to.be.false


    it "handles permuted piece names", ->
      ufr_fr = exp("UFR FR")
      expect(ufr_fr.matches_sticker("FRU", "F")).to.be.true
      expect(ufr_fr.matches_sticker("URF", "F")).to.be.true
      expect(ufr_fr.matches_sticker("RF", "F")).to.be.true
      expect(ufr_fr.matches_sticker("UFFR", "F")).to.be.false

