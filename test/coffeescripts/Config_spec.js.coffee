#= require roofpig/Config

describe "Config", ->
  it "has defaults", ->
    empty_config = new Config("")
    expect(empty_config.alg).to.equal("")
    expect(empty_config.hover).to.equal(2.0)
    expect(empty_config.flags).to.equal("")
    expect(empty_config.pov).to.equal("Ufr")
    expect(empty_config.setup).to.equal("")

    expect(empty_config.colors).to.exist

  describe "flags", ->
    it "recognizes flags", ->
      config = new Config("flags=fast shiny")
      expect(config.flags).to.equal("fast shiny")
      expect(config.flag("fast")).to.be.true
      expect(config.flag("slow")).to.be.false

    it "handles moreflags", ->
      config = new Config("flags=fast| moreflags=shiny")
      expect(config.flags).to.equal("fast shiny")
      expect(config.flag("fast")).to.be.true
      expect(config.flag("slow")).to.be.false

  describe "base", ->
    window["ROOFPIG_CONF_TEST"] = "hover=3.3"

    it "reads config and base", ->
      config = new Config("flags=fast shiny| base=TEST")
      expect(config.flags).to.equal("fast shiny")
      expect(config.hover).to.equal("3.3")

    it "config overrides base", ->
      config = new Config("hover=2.5| base=TEST")
      expect(config.hover).to.equal("2.5")

    it "handles non existent base", ->
      config = new Config("hover=2.5| base=NOTHING")
      expect(config.hover).to.equal("2.5")
      #TODO expect error message

  describe "@_parse", ->
    it "makes an object", ->
      expect(Config._parse("abc=123|x = 42")).to.deep.equal({abc: '123', x:'42'})