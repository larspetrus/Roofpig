#= require three.min
#= require roofpig/Camera
#= require roofpig/CubeAnimation
#= require roofpig/EventHandlers

mock_div = {
  data: ->
  css: ->
  width: ->
  append: ->
}

new_cube = -> new CubeAnimation(mock_div, true, true)

describe "CubeAnimation", ->
  beforeEach ->
    CubeAnimation.unique_id = 0
    CubeAnimation.instances = []

  it "gives the keyboard focus to the first CubeAnimation created", ->
    expect(EventHandlers.focus).to.equal(undefined)

    c1 = new_cube()
    expect(EventHandlers.focus).to.equal(c1)

    c2 = new_cube()
    expect(EventHandlers.focus).to.equal(c1)

  it "@id, #next_cube(), #previous_cube()", ->
    c1 = new_cube()
    c2 = new_cube()
    c3 = new_cube()

    expect(c1.id).to.equal(1)
    expect(c2.id).to.equal(2)
    expect(c3.id).to.equal(3)

    expect(c1.next_cube()).to.equal(c2)
    expect(c2.next_cube()).to.equal(c3)
    expect(c3.next_cube()).to.equal(c1)

    expect(c1.previous_cube()).to.equal(c3)
    expect(c2.previous_cube()).to.equal(c1)
    expect(c3.previous_cube()).to.equal(c2)

