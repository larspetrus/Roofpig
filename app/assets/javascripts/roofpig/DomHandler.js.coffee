class @DomHandler

  constructor: (@display_id, @div, renderer) ->
    @div.css(position:'relative')
    this.keyboard_focus(false)
    @div.data('dpid', @display_id)

    renderer.setSize(@div.width(), @div.width())
    @div.append(renderer.domElement);

    @scale = @div.width()/400

  keyboard_focus: (has_it) ->
    color = if has_it then 'gray' else '#eee'
    @div.css("border": "2px solid #{color}")

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
          when @reset, @prev
            this._show(button, not at_start)
          when @next, @play
            this._show(button, not at_end)
          when @pause
            button.hide()

    @play_or_pause = if playing then @pause else @play

    @place.html(place_text)

  add_alg_buttons: ->
    @button_area = $("<div/>", { class: 'button-area' }).height(@div.height() - @div.width()).width(@div.width())
    @div.append(@button_area)

    @reset = this._make_button("↩",  "reset")
    @prev  = this._make_button("-",  "prev")
    @next  = this._make_button("+",  "next")
    @pause = this._make_button("||", "pause")
    @play  = this._make_button("▶",  "play")

    @place = this._scale($("<div/>", { id: "place" }).css("text-align": 'right', 'float': 'right'))

    @buttons = [@reset, @prev, @next, @pause, @play]


  _show: (button, active) ->
    button.show()
    if active
      button.removeAttr("disabled")
    else
      button.attr("disabled", "disabled")


  _make_button: (text, id) ->
    this._scale($("<button/>", { text: text, id: id, 'data-dpid': @display_id }))

  _scale: (button_area_element) ->
    @button_area.append(button_area_element)
    button_area_element.height(40 * @scale).width(72 * @scale - 12).css("font-size", 32 * @scale)