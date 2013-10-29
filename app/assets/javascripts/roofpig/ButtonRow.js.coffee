class @ButtonRow
  constructor: ->
    @reset = this._make("↺",  "reset")
    @prev  = this._make("-",  "prev").attr("disabled", "disabled")
    @next  = this._make("+",  "next")
    @pause = this._make("||", "pause").hide()
    @play  = this._make("▶",  "play")
    @all = [@reset, @prev, @next, @pause, @play]

  update: (playing, at_start, at_end) ->
    if playing
      for button in @all
        if button == @play
          button.hide()
        else
          this._show(button, button == @pause)
    else
      for button in @all
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


  _show: (button, active) ->
    button.show()
    if active
      button.removeAttr("disabled")
    else
      button.attr("disabled", "disabled")


  _make: (text, id) ->
    $("<button/>", { text: text, id: id })
