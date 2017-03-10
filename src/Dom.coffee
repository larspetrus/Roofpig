class Dom

  constructor: (@cube_id, @div, renderer, make_alg_area, showalg) ->
    @div.css(position:'relative', 'font-family':'"Lucida Sans Unicode", "Lucida Grande", sans-serif')
    this.has_focus(false)
    @div.attr('data-cube-id', @cube_id)

    renderer.setSize(@div.width(), @div.width())
    @div.append(renderer.domElement);

    @scale = @div.width()/400
    @hscale = Math.max(@scale, 15.0/40) # Minimum height -> readable text

    if make_alg_area
      this.add_alg_area(showalg)

  has_focus: (has_it) ->
    color = if has_it then 'gray' else '#eee'
    cursor = if has_it then 'pointer' else 'default'
    @div.css(border: "2px solid #{color}", cursor: cursor)

  alg_changed: (is_playing, at_start, at_end, count_text, alg_texts) ->
    if is_playing
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

    @play_or_pause = if is_playing then @pause else @play

    @count.html(count_text)

    if @alg_text
      @alg_past.text(alg_texts.past)
      @alg_future.text(" "+ alg_texts.future)

  show_help: ->
    @help = $("<div/>").addClass('roofpig-help')
    @help.append(
      $("<div>Keyboard shortcuts</div>").css('text-align': 'center', 'font-weight': 'bold'),
      "<div><span>→</span> - Next move</div>",
      "<div/><span>←</span> - Previous move</div>",
      "<div/><span>⇧</span>+<span>→</span> - To end</div>",
      "<div/><span>⇧</span>+<span>←</span> - To start</div>",
      "<div/><span>&nbsp;space&nbsp;</span> - Play/Pause</div>",
      "<div/><span>Tab</span> - Next Cube</div>"
    )

    @div.append(@help)
    @help.css(right: "#{(@div.width()-@help.outerWidth())/2}px")

  remove_help: ->
    if @help
      @help.remove()
      @help = null
      was_removed = true
    was_removed

  add_alg_area: (showalg) ->
    @div.append($("<div/>", text: '?', id: "help-#{@cube_id}").addClass('roofpig-help-button'))

    @alg_area = $("<div/>").height(@div.height() - @div.width()).width(@div.width()).css("border-top": "1px solid #ccc")
    @div.append(@alg_area)

    if showalg
      @alg_text = $("<div/>").width(@div.width()).addClass("roofpig-algtext")
      @alg_area.append(@alg_text)

      @alg_past = $("<span/>").addClass("roofpig-past-algtext")
      @alg_future = $("<span/>")
      @alg_text.append(@alg_past, @alg_future)

    @reset = this._make_button("↩", "reset")
    @prev  = this._make_button("-", "prev")
    @next  = this._make_button("+", "next")
    @pause = this._make_button("Ⅱ", "pause")
    @play  = this._make_button("▶", "play")

    @count = this._make_count_area()

    @buttons = [@reset, @prev, @next, @pause, @play]

  LUCIDA_WIDTHS = {M:108, '+':100, '>':100, '<':100, w:98, D:94, U:87, 2:80, R:80, x:78, Z:77, B:73, z:73, F:68, E:68, S:68, L:67, y:65, '²':53, ' ':40, "'":29}
  init_alg_text: (text) ->
    if @alg_text
      width = 0
      for char in text.split('')
        width += LUCIDA_WIDTHS[char] || 80
        unless LUCIDA_WIDTHS[char] then log_error("Unknown char width: '#{char}'")

      font_size = 24 * @scale * Math.min(1, 1970/width)
      @alg_text.height(1.2 * font_size).css("font-size": font_size)

  _show: (button, enabled) ->
    button.show()
    if enabled
      button.prop("disabled", false)
      button.addClass('roofpig-button-enabled')
    else
      button.prop("disabled", true)
      button.removeClass('roofpig-button-enabled')

  _make_button: (text, name) ->
    button = $("<button/>", text: text, id: "#{name}-#{@cube_id}")
    @alg_area.append(button)

    button.addClass('roofpig-button')
    button.css('font-size': 28*@hscale, float: 'left', height: 40*@hscale, width: 76*@scale)

  _make_count_area: ->
    count_div = $("<div/>", id: "count-#{@cube_id}").addClass('roofpig-count')
    @alg_area.append(count_div)
    count_div.height(40*@hscale).width(80*@scale).css("font-size", 24*@hscale)
