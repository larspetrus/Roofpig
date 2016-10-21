#= require Layer

describe "Layer", ->
  it "#shift", ->
    expect(Layer.F.shift('L', 1)).to.equal('U')
    expect(Layer.F.shift('L', 2)).to.equal('R')
    expect(Layer.F.shift('L', 3)).to.equal('D')

    expect(Layer.F.shift('F', 1)).to.equal('F')
    expect(Layer.F.shift('Q', 1)).to.be.null
    expect(-> Layer.F.shift('F', 0)).to.throw(Error)

  it "on_same_axis_as", ->
    expect(Layer.F.on_same_axis_as(Layer.B)).to.be.true
    expect(Layer.F.on_same_axis_as(Layer.F)).to.be.true
    expect(Layer.F.on_same_axis_as(Layer.U)).to.be.false
    expect(Layer.M.on_same_axis_as(Layer.L)).to.be.true
    expect(Layer.M.on_same_axis_as(Layer.B)).to.be.false