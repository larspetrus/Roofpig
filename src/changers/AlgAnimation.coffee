class AlgAnimation
  constructor: (@alg) ->
    this._next_alg_move()

  update: (now) ->
    return if @_finished

    if @move_changer.finished()
      this._next_alg_move()

    @move_changer.update(now)

  finish: ->
    # API creep

  finished: ->
    @_finished

  _next_alg_move: ->
    if @alg.at_end() || not @alg.playing
      @_finished = true
    else
      @move_changer = @alg.next_move().show_do()
