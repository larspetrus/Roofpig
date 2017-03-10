#= require three.min
#= require jquery-3.1.1.min.js
#= require Camera
#= require CubeAnimation
#= require EventHandlers

mock_div = {
  data: ->
  css: ->
  width: ->
  append: ->
  attr: ->
  remove: ->
}

new_cube = -> new CubeAnimation(mock_div)

describe "CubeAnimation", ->
  beforeEach ->
    CubeAnimation.webgl_browser = true
    CubeAnimation.canvas_browser = true
    CubeAnimation.last_id = 0
    CubeAnimation.by_id = []
    EventHandlers.initialize

  it "gives the keyboard focus to the first CubeAnimation created", ->
    expect(EventHandlers.focus().is_null).to.equal(true)

    c1 = new_cube()
    expect(EventHandlers.focus()).to.equal(c1)

    c2 = new_cube()
    expect(EventHandlers.focus()).to.equal(c1)

  it "@id, #next_cube(), #previous_cube()", ->
    [c1, c2, c3] = [new_cube(), new_cube(), new_cube()]

    expect(c1.id).to.equal(1)
    expect(c2.id).to.equal(2)
    expect(c3.id).to.equal(3)

    expect(c1.next_cube()).to.equal(c2)
    expect(c2.next_cube()).to.equal(c3)
    expect(c3.next_cube()).to.equal(c1)

    expect(c1.previous_cube()).to.equal(c3)
    expect(c2.previous_cube()).to.equal(c1)
    expect(c3.previous_cube()).to.equal(c2)

    c2.remove()

    expect(c1.next_cube()).to.equal(c3)
    expect(c3.next_cube()).to.equal(c1)
    expect(c1.previous_cube()).to.equal(c3)
    expect(c3.previous_cube()).to.equal(c1)

  it "removes focus from deleted cubes", ->
    [c1, c2] = [new_cube(), new_cube()]
    expect(EventHandlers.focus()).to.equal(c1)

    c1.remove()

    expect(EventHandlers.focus()).to.equal(c2)

    c2.remove()

    expect(EventHandlers.focus().is_null).to.equal(true)

