#= require roofpig/CubeExp

exp = (e) -> new CubeExp(e)

describe "CubeExp", ->
  describe "matches", ->
    it "simple piece names", ->
      expect(JSON.stringify(exp("UFR").matches)).to.equal(JSON.stringify(exp("UFR").matches))
      expect(exp("UFR").matches).to.deep.equal(exp("UFR").matches)
      expect(exp("UFR FL").matches).to.deep.equal(exp("UFR FL").matches)
      expect(exp("").matches).to.deep.equal(exp("").matches)
      expect(exp(null).matches).to.deep.equal(exp("").matches)

    it "Shorthand syntax", ->
      expect(exp("UFR*").matches).to.deep.equal(exp("UFR UF UR FR U F R").matches)

      expect(exp("U*").matches).to.deep.equal(exp("U UB UBL UBR UF UFL UFR UL UR").matches)
      expect(exp("F*").matches).to.deep.equal(exp("DF DFL DFR F FL FR UF UFL UFR").matches)

      expect(exp("B-").matches, 5).to.deep.equal(exp("D DF DFL DFR DL DR F FL FR L R U UF UFL UFR UL UR").matches)
      expect(exp("BF-").matches, 6).to.deep.equal(exp("D DL DR L R U UL UR").matches)
      expect(exp("BL-").matches, 7).to.deep.equal(exp("D DF DFR DR F FR R U UF UFR UR").matches)

      expect(exp("*").matches).to.deep.equal(exp("B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR").matches)

      expect(exp("f").matches).to.deep.equal(exp("dF dFl dFr F Fl Fr uF uFl uFr").matches)

    it "type filter syntax", ->
      expect(exp("UFR*/e").matches).to.deep.equal(exp("UF UR FR").matches)

      expect(exp("U*/c").matches).to.deep.equal(exp("UBL UBR UFL UFR").matches)
      expect(exp("F*/cm").matches).to.deep.equal(exp("DFL DFR F UFL UFR").matches)

      expect(exp("B-/m").matches).to.deep.equal(exp("D F L R U").matches)

      expect(exp("*/ce").matches).to.deep.equal(exp("BL BR DB DBL DBR DF DFL DFR DL DR FL FR UB UBL UBR UF UFL UFR UL UR").matches)

      expect(exp("f/me").matches).to.deep.equal(exp("dF F Fl Fr uF").matches)

    it "permuted names", ->
      expect(exp("FRU").matches).to.deep.equal(exp("UFR").matches)
      expect(exp("FUR LF").matches).to.deep.equal(exp("UFR FL").matches)
      expect(exp("FRU*").matches).to.deep.equal(exp("UFR UF UR FR U F R").matches)

    it "ignores ill formed expressions", ->
      expect(exp("UF*").matches).to.deep.equal(exp("").matches)

    it "selections accumulate", ->
      expect(exp("Ufr ufR").matches).to.deep.equal(exp("UfR").matches)
      expect(exp("UF f/e").matches).to.deep.equal(exp("UF Fl Fr dF").matches)


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

