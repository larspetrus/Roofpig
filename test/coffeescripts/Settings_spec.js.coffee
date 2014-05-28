#= require roofpig/Settings

describe "Settings", ->
  it "has defaults", ->
    empty_settings = new Settings({ data: -> null })
    expect(empty_settings.alg).to.equal("")
    expect(empty_settings.hover).to.equal(2.0)
    expect(empty_settings.flags).to.equal("")
    expect(empty_settings.pov).to.equal("Ufr")
    expect(empty_settings.setup).to.equal("")

    expect(empty_settings.colors).to.exist

  describe "flags", ->
    it "recognizes flags", ->
      settings = new Settings({ data: (name) -> {flags: "fast shiny"}[name] })
      expect(settings.flags).to.equal("fast shiny")
      expect(settings.flag("fast")).to.be.true
      expect(settings.flag("slow")).to.be.false

    it "handles moreflags", ->
      settings = new Settings({ data: (name) -> {flags: "fast", moreflags: "shiny", }[name] })
      expect(settings.flags).to.equal("fast shiny")
      expect(settings.flag("fast")).to.be.true
      expect(settings.flag("slow")).to.be.false

  describe "prefs", ->
    prefs = { hover: "3.3"}

    it "reads prefs and settings", ->
      settings = new Settings({ data: (name) -> {flags: "fast shiny"}[name] }, prefs)
      expect(settings.flags).to.equal("fast shiny")
      expect(settings.hover).to.equal("3.3")

    it "settings override prefs", ->
      settings = new Settings({ data: (name) -> {hover: "2.5"}[name] }, prefs)
      expect(settings.hover).to.equal("2.5")