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

  it "#as_brdflu", ->
    expect(new CompositeMove("R+M'").as_brdflu()).to.equal("L")    # Rw
    expect(new CompositeMove("R+M'+L'").as_brdflu()).to.equal("")  # x
    expect(new CompositeMove("U'+E+D").as_brdflu()).to.equal("")  # y'
    expect(new CompositeMove("U2+E2+D2").as_brdflu()).to.equal("")  # y2
    expect(new CompositeMove("B'+S").as_brdflu()).to.equal("F'")  # Bw'
    expect(new CompositeMove("B2+S2").as_brdflu()).to.equal("F2")  # Bw2
    expect(new CompositeMove("R2+M2+L2").as_brdflu()).to.equal("")  # x
    expect(new CompositeMove("U>+L").as_brdflu()).to.equal("L")

  it "#track_pov", ->
    map = Pov.start_map()

    new CompositeMove("U2+D").track_pov(map)
    expect(map).to.deep.equal(Pov.start_map())

    new CompositeMove("B'+S").track_pov(map)
    expect(map).to.deep.equal(B: "B", D: "L", F: "F", L: "U", R: "D", U: "R")
