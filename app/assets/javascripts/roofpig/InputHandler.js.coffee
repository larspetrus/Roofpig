class @InputHandler
  keysDown: []

  constructor: (@world) ->
    $("body").keydown (e) =>
      @keysDown.push({key: String.fromCharCode(e.keyCode), ctrl: e.ctrlKey, shift: e.shiftKey})

  next_key: ->
    @keysDown.shift()
