#= require changers/ConcurrentChangers

describe "ConcurrentChangers", ->
  it "#finished", ->
    true_func = -> true
    false_func = -> false

    c1 = { finished: false_func }
    c2 = { finished: false_func }

    cc = new ConcurrentChangers([c1, c2])
    expect(cc.finished()).to.be.false

    c1.finished = true_func
    expect(cc.finished()).to.be.false

    c2.finished = true_func
    expect(cc.finished()).to.be.true
