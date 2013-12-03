#= require roofpig/Settings

describe "Settings#constructor", ->
  it "has defaults", ->
    empty_settings = new Settings({ data: -> null })
    expect(empty_settings.alg).to.equal("")
    expect(empty_settings.hover).to.equal(6.5)
    expect(empty_settings.color_only).to.equal(" B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR ")
    expect(empty_settings.flags).to.equal("")

describe "Settings#flag", ->
  it "reads a move string", ->
    ss = new Settings({ data: (name) -> {flags: "fast shiny"}[name] })
    expect(ss.flags, 1).to.equal("fast shiny")
    expect(ss.flag("fast")).to.equal(true)
    expect(ss.flag("slow")).to.equal(false)

  describe "_expand_sticker_exp", ->
    it "Passes through the simple", ->
      expect(Settings._expand_sticker_exp("UFR")).to. equal(" UFR ")
      expect(Settings._expand_sticker_exp("UFR FL")).to. equal(" UFR FL ")

    it "Expands wild cards", ->
      expect(Settings._expand_sticker_exp("UFR*")).to. equal(" UFR UF UR FR U F R ")

      expect(Settings._expand_sticker_exp("U*")).to. equal(" U UB UBL UBR UF UFL UFR UL UR ")
      expect(Settings._expand_sticker_exp("F*")).to. equal(" DF DFL DFR F FL FR UF UFL UFR ")

      expect(Settings._expand_sticker_exp("")).to. equal(" B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR ")
      expect(Settings._expand_sticker_exp(null)).to. equal(" B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR ")


