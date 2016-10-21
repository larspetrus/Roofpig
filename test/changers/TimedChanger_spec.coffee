#= require changers/TimedChanger

describe "TimedChanger", ->
  it "easing starts and ends properly", ->
    c = new TimedChanger(1.0)
    expect(c._ease(c.start_time)).to.equal(0.0)
    expect(c._ease(c.start_time + c.duration)).to.equal(c.duration)