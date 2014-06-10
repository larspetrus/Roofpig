#= require three.min
#= require roofpig/Move
#= require roofpig/Rotation
#= require roofpig/CompositeMove

describe "CompositeMove", ->
  it "works", ->
    cm = new CompositeMove([new Move("L"), new Rotation("F>"), new Move("R")])
    expect(cm.to_s()).to.equal("(L F> R)")
    expect(cm.display_text()).to.equal("L+R")
    expect(cm.count()).to.equal(2)

  it "x, y &z should report as 1 move, not 3", ->
    cm = new CompositeMove([new Move("L"), new Move("M")], "Lw")
    expect(cm.to_s()).to.equal("(L M)")
    expect(cm.display_text()).to.equal("Lw")
    expect(cm.count()).to.equal(1)
