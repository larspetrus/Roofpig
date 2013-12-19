#= require roofpig/Settings

describe "Settings#constructor", ->
  it "has defaults", ->
    empty_settings = new Settings({ data: -> null })
    expect(empty_settings.alg).to.equal("")
    expect(empty_settings.hover).to.equal(6.5)
    expect(empty_settings.flags).to.equal("")
    expect(empty_settings.setup).to.equal("")

    expect(empty_settings.colors).to.exist

describe "Settings#flag", ->
  it "reads a move string", ->
    settings = new Settings({ data: (name) -> {flags: "fast shiny"}[name] })
    expect(settings.flags).to.equal("fast shiny")
    expect(settings.flag("fast")).to.equal(true)
    expect(settings.flag("slow")).to.equal(false)

  describe "prefs", ->
    it "reads prefs and settings", ->
      settings = new Settings({ data: (name) -> {flags: "fast shiny"}[name] }, { hover: "3.3"})
      expect(settings.flags).to.equal("fast shiny")
      expect(settings.hover).to.equal("3.3")

    it "settings override prefs", ->
      settings = new Settings({ data: (name) -> {hover: "2.5"}[name] }, { hover: "3.3"})
      expect(settings.hover).to.equal("2.5")
