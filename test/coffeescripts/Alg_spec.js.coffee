#= require roofpig/Alg

describe "Alg#constructor", ->
  it "works", ->
    expect(new Alg("U F2 D''").to_s()).to.equal("U1 F2 D3")
