class @AlgAnimation
  constructor: (@alg) ->
    this._next_alg_move()

  update: (now) ->
    return if @_finished

    if @changer.finished()
      this._next_alg_move()

    @changer.update(now)

  finish: ->
    # API creep

  finished: ->
    @_finished

  _next_alg_move: ->
    if @alg.at_end() || not @alg.playing
      @_finished = true
    else
      @changer = @alg.next_move().show_do()
