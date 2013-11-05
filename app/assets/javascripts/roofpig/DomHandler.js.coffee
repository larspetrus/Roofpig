class @DomHandler
  constructor: (@display_id, @div, renderer) ->
    @div.css(position:'relative')

    renderer.setSize(@div.width(), @div.width())
    @div.append(renderer.domElement);

    @button_area = $("<div/>", { class: 'button-area' }).height(@div.height() - @div.width()).width(@div.width())
    @div.append(@button_area)

    @scale = @div.width()/400

    @reset = this._make_button("↺",  "reset")
    @prev  = this._make_button("-",  "prev")
    @next  = this._make_button("+",  "next")
    @pause = this._make_button("||", "pause")
    @play  = this._make_button("▶",  "play")

    @place = this._assimilate($("<div/>", { id: "place" }).css("text-align": 'right', 'float': 'right'))

    @buttons = [@reset, @prev, @next, @pause, @play]

  alg_changed: (playing, at_start, at_end, place_text) ->
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

    @place.html(place_text)


  _show: (button, active) ->
    button.show()
    if active
      button.removeAttr("disabled")
    else
      button.attr("disabled", "disabled")


  _make_button: (text, id) ->
    this._assimilate($("<button/>", { text: text, id: id, 'data-dpid': @display_id }))

  _assimilate: (button_area_element) ->
    @button_area.append(button_area_element)
    button_area_element.height(40 * @scale).width(60 * @scale).css("font-size", 24 * @scale)