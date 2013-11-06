class @AlgAnimation
  constructor: (@alg, @pieces3d) ->
    this._next_alg_move()

  update: (now) ->
    return if @finished

    if @mover.finished
      this._next_alg_move()

    @mover.update(now)

  finish: ->
    # API creep

  _next_alg_move: ->
    if @alg.at_end() || not @alg.playing
      @finished = true
    else
      @mover = @alg.next_move().do(@pieces3d)
