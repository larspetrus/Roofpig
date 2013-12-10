#= require three.min.js
#= require roofpig/utils

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

  describe "#standard_piece_name", ->
    it "returns the right names, independent of order", ->
      standard_piece_name('F', 'R').should.equal("FR")
      standard_piece_name('R', 'F').should.equal("FR")
      standard_piece_name('R', 'F', 'D').should.equal("DFR")

    it "handles Side objects", ->
      standard_piece_name({name: 'F'}, {name: 'R'}).should.equal("FR")

    it "ignores non official Sides", ->
      expect(standard_piece_name('F', 'Bob', 'R')).to.equal("FR")

  describe "#standardize_name", ->
      it "works", ->
        expect(standardize_name("LDF")).to.equal("DFL")
        expect(standardize_name("LdF")).to.equal("FL")
        expect(standardize_name("RDFL")).to.equal("DFR")
        expect(standardize_name("x UD")).to.equal("U")

  describe "#side_name", ->
    it "works with strings, Side objects and nulls", ->
      expect(side_name("F")).to.equal("F")
      expect(side_name({name: "D"})).to.equal("D")
      expect(side_name()).to.equal("")