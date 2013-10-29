class @Buttons
  @new_buttons: ->
    [this._button("↺",  "reset"),
     this._button("-",  "prev"),
     this._button("+",  "next"),
     this._button("||", "pause").hide(),
     this._button("▶",  "play")]

  @_button: (text, id) ->
    $("<button/>", { text: text, id: id })