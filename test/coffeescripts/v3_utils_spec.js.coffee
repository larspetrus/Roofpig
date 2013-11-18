#= require three.min.js
#= require roofpig/v3_utils

describe "v3", ->
  it "#constructor", ->
    v123 = v3(1, 2, 3)
    expect(v123.x).to.equal(1)
    expect(v123.y).to.equal(2)
    expect(v123.z).to.equal(3)

  it "#add", ->
    sum = v3_add(v3(1, 2, 3), v3(4, 5, 6))
    expect(sum.x).to.equal(5)
    expect(sum.y).to.equal(7)
    expect(sum.z).to.equal(9)

  it "#sub", ->
    diff = v3_sub(v3(5, 6, 7), v3(3, 2, 1))
    expect(diff.x).to.equal(2)
    expect(diff.y).to.equal(4)
    expect(diff.z).to.equal(6)
