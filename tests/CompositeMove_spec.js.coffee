#= require three.min
#= require roofpig/Config
#= require roofpig/CompositeMove
#= require roofpig/Move

describe "CompositeMove", ->
  it "works", ->
    cm = new CompositeMove([new Move("L"), new Move("F>"), new Move("R")])
    expect(cm.to_s()).to.equal("(L F> R)")
    expect(cm.display_text({})).to.equal("L+R")
    expect(cm.count()).to.equal(2)

  it "x, y, z, and Sw should report as 1 move, not 3", ->
    lw = new CompositeMove([new Move("L"), new Move("M")], "Lw")
    expect(lw.to_s()).to.equal("(L M)")
    expect(lw.display_text({})).to.equal("Lw")
    expect(lw.count()).to.equal(1)

  it "x, y, z, and Sw should respect the algdisplay settings", ->
    xz = new CompositeMove([], "xZ")
    expect(xz.display_text(new Config("").algdisplay)).to.equal("x2")
    expect(xz.display_text(new Config("algdisplay=fancy2s").algdisplay)).to.equal("x²")
    expect(xz.display_text(new Config("algdisplay=2p").algdisplay)).to.equal("x2'")
