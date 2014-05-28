#= require roofpig/Config

describe "Config", ->
  it "has defaults", ->
    empty_config = new Config({ data: -> null })
    expect(empty_config.alg).to.equal("")
    expect(empty_config.hover).to.equal(2.0)
    expect(empty_config.flags).to.equal("")
    expect(empty_config.pov).to.equal("Ufr")
    expect(empty_config.setup).to.equal("")

    expect(empty_config.colors).to.exist

  describe "flags", ->
    it "recognizes flags", ->
      config = new Config({ data: (name) -> {flags: "fast shiny"}[name] })
      expect(config.flags).to.equal("fast shiny")
      expect(config.flag("fast")).to.be.true
      expect(config.flag("slow")).to.be.false

    it "handles moreflags", ->
      config = new Config({ data: (name) -> {flags: "fast", moreflags: "shiny", }[name] })
      expect(config.flags).to.equal("fast shiny")
      expect(config.flag("fast")).to.be.true
      expect(config.flag("slow")).to.be.false

  describe "prefs", ->
    prefs = { hover: "3.3"}

    it "reads prefs and config", ->
      config = new Config({ data: (name) -> {flags: "fast shiny"}[name] }, prefs)
      expect(config.flags).to.equal("fast shiny")
      expect(config.hover).to.equal("3.3")

    it "config override prefs", ->
      config = new Config({ data: (name) -> {hover: "2.5"}[name] }, prefs)
      expect(config.hover).to.equal("2.5")

  describe "@_parse", ->
    it "makes an object", ->
      expect(Config._parse("abc=123|x = 42")).to.deep.equal({abc: '123', x:'42'})