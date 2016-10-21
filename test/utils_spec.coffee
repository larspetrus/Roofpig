#= require three.min.js
#= require <utils.coffee>

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

  it "#x", ->
    whole = v3(2, 4, 6)
    half = v3_x(whole, 0.5)
    expect(half.x).to.equal(whole.x/2)
    expect(half.y).to.equal(whole.y/2)
    expect(half.z).to.equal(whole.z/2)

  describe "#standardize_name", ->
      it "ignores non side names, and only looks at 3 first characters", ->
        expect(standardize_name("LDF")).to.equal("DFL")
        expect(standardize_name("LdF")).to.equal("FL")
        expect(standardize_name("RDFL")).to.equal("DFR")
        expect(standardize_name("x UD")).to.equal("U")

  describe "#side_name", ->
    it "works with strings, Layer objects and nulls", ->
      expect(side_name("F")).to.equal("F")
      expect(side_name({name: "D"})).to.equal("D")
      expect(side_name()).to.equal("")