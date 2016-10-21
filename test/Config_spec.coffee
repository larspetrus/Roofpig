#= require Config

errors = []

@log_error = (text) ->
  errors.push(text)

describe "Config", ->
  it "has defaults", ->
    empty_config = new Config("")
    expect(empty_config.alg).to.equal("")
    expect(empty_config.hover).to.equal(2.0)
    expect(empty_config.flags).to.equal("")
    expect(empty_config.pov).to.equal("Ufr")
    expect(empty_config.setup).to.equal("")

    expect(empty_config.colors).to.exist

  it "recognizes flags", ->
    config = new Config("flags=fast shiny")
    expect(config.flags).to.equal("fast shiny")
    expect(config.flag("fast")).to.be.true
    expect(config.flag("slow")).to.be.false

  it "hover aliases", ->
    expect(new Config("").hover).to.equal(2.0)
    expect(new Config("hover=3.14").hover).to.equal('3.14')
    expect(new Config("hover=none").hover).to.equal(1.0)
    expect(new Config("hover=near").hover).to.equal(2.0)
    expect(new Config("hover=far" ).hover).to.equal(7.1)

  it "detects illegal parameters", ->
    config = new Config("shower=100% | hover=8")
    expect(errors.join()).to.equal("Unknown config parameter 'shower' ignored")
    expect(config.hover).to.equal('8')

  describe "base", ->
    window["ROOFPIG_CONF_TEST"] = "hover=3.3"

    it "reads config and base", ->
      config = new Config("flags=fast shiny| base=TEST")
      expect(config.flags).to.equal("fast shiny")
      expect(config.hover).to.equal("3.3")

    it "config overrides base", ->
      expect(new Config("hover=2.5| base=TEST").hover).to.equal("2.5")

    it "handles non existent base", ->
      expect(new Config("hover=2.5| base=NOTHING").hover).to.equal("2.5")
      #TODO expect error message

    it "recurses", ->
      window["ROOFPIG_CONF_ROOT"] = "flags=t1"
      window["ROOFPIG_CONF_BASE"] = "base=ROOT | pov=t2"
      leaf_config = new Config("hover=2.5| base=BASE")
      expect(leaf_config.flags).to.equal("t1")
      expect(leaf_config.pov).to.equal("t2")

    it "breaks infinite recursion", ->
      window["ROOFPIG_CONF_ME"] = "base=ME | flags=abc"
      expect(new Config("hover=2.5| base=ME").flags).to.equal("abc")


  describe "@_parse", ->
    it "makes an object", ->
      expect(Config._parse("abc=123|x = 42")).to.deep.equal({abc: '123', x:'42'})