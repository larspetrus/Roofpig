describe "EventHandlers", ->

  it "@_turns", ->
    expect(EventHandlers._turns({shiftKey: false, altKey: false})).to.equal('')
    expect(EventHandlers._turns({shiftKey: false, altKey:  true})).to.equal('2')
    expect(EventHandlers._turns({shiftKey:  true, altKey: false})).to.equal("'")
    expect(EventHandlers._turns({shiftKey: false, altKey:  true})).to.equal('2')

    expect(EventHandlers._turns({shiftKey: false, altKey: false}, true)).to.equal("'")
    expect(EventHandlers._turns({shiftKey: false, altKey:  true}, true)).to.equal('Z')
    expect(EventHandlers._turns({shiftKey:  true, altKey: false}, true)).to.equal('')
    expect(EventHandlers._turns({shiftKey: false, altKey:  true}, true)).to.equal('Z')

