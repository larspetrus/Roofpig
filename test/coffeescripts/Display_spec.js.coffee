#= require three.min
#= require roofpig/Camera
#= require roofpig/Display
#= require roofpig/InputHandler

mock_div = {
  data: ->
  css: ->
  width: ->
  append: ->
}

describe "Display", ->
  beforeEach ->
    Display.unique_id = 0
    Display.instances = []

  it "gives the keyboard focus to the first Display created", ->
    expect(InputHandler.active_display, 1).to.equal(undefined)

    d1 = new Display(mock_div)
    expect(InputHandler.active_display, 2).to.equal(d1)

    d2 = new Display(mock_div)
    expect(InputHandler.active_display, 3).to.equal(d1)

  it "@id, #next_display(), #previous_display()", ->
    d1 = new Display(mock_div)
    d2 = new Display(mock_div)
    d3 = new Display(mock_div)

    expect(d1.id).to.equal(1)
    expect(d2.id).to.equal(2)
    expect(d3.id).to.equal(3)

    expect(d1.next_display(), 1).to.equal(d2)
    expect(d2.next_display(), 2).to.equal(d3)
    expect(d3.next_display(), 3).to.equal(d1)

    expect(d1.previous_display(), 4).to.equal(d3)
    expect(d2.previous_display(), 5).to.equal(d1)
    expect(d3.previous_display(), 6).to.equal(d2)

