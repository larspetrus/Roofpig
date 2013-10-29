class @ButtonRow
  constructor: ->
    @reset = this._make("↺",  "reset")
    @prev  = this._make("-",  "prev")
    @next  = this._make("+",  "next")
    @pause = this._make("||", "pause")
    @play  = this._make("▶",  "play")
    @place = $("<div/>", { id: "place" })

    @buttons = [@reset, @prev, @next, @pause, @play]
    @all = @buttons.concat [@place]


  update: (playing, at_start, at_end, place) ->
    if playing
      for button in @buttons
        if button == @play
          button.hide()
        else
          this._show(button, button == @pause)
    else
      for button in @buttons
        switch button
          when @reset
            this._show(button, true)
          when @prev
            this._show(button, not at_start)
          when @next
            this._show(button, not at_end)
          when @pause
            button.hide()
          when @play
            this._show(button, not at_end)

    @place.html(place)


  _show: (button, active) ->
    button.show()
    if active
      button.removeAttr("disabled")
    else
      button.attr("disabled", "disabled")


  _make: (text, id) ->
    $("<button/>", { text: text, id: id })
