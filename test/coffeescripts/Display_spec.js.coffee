#= require roofpig/Display
#= require roofpig/InputHandler

describe "Display#const", ->
  it "should give the keyboard focus to the first Display created", ->
    expect(InputHandler.display_with_focus, 1).to.equal(null)
    d1 = new Display({})
    expect(InputHandler.display_with_focus, 1).to.equal(d1)
    d2 = new Display({})
    expect(InputHandler.display_with_focus, 1).to.equal(d1)

