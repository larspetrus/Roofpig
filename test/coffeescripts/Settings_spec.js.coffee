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
    ss = new Settings({ data: (name) -> {flags: "fast shiny"}[name] })
    expect(ss.flags, 1).to.equal("fast shiny")
    expect(ss.flag("fast")).to.equal(true)
    expect(ss.flag("slow")).to.equal(false)



