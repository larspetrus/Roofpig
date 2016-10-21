#= require three.min
#= require Config
#= require CompositeMove
#= require Move

describe "CompositeMove", ->
  it "works", ->
    cm = new CompositeMove("L+F>+R", {}, 200)
    expect(cm.to_s()).to.equal("(L F> R)")
    expect(cm.display_text({})).to.equal("L+R")
    expect(cm.count()).to.equal(2)

  it "x, y, z, and Sw should report as 1 move, not 3", ->
    lw = new CompositeMove("L+M", {}, 200, "Lw")
    expect(lw.to_s()).to.equal("(L M)")
    expect(lw.display_text({})).to.equal("Lw")
    expect(lw.count()).to.equal(1)

  it "x, y, z, and Sw should respect the algdisplay settings", ->
    xz = new CompositeMove("U", {}, 200, "xZ")
    expect(xz.display_text(new Config("").algdisplay)).to.equal("x2")
    expect(xz.display_text(new Config("algdisplay=fancy2s").algdisplay)).to.equal("x²")
    expect(xz.display_text(new Config("algdisplay=2p").algdisplay)).to.equal("x2'")

  it "detects impossible move combinations", ->
    expect(-> new CompositeMove("L+F", {}, 200)).to.throw("Impossible Move combination 'L+F'")
    expect(-> new CompositeMove("U>+L", {}, 200)).to.not.throw(Error)
