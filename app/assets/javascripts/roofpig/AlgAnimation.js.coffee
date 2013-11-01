class @AlgAnimation
  constructor: (@alg, @pieces3d) ->
    this._next_alg_move()

  animate: ->
    return if @finished

    if @move_animation.finished
      this._next_alg_move()

    @move_animation.animate()

  finish: ->
    # API creep

  _next_alg_move: ->
    if @alg.at_end() || not @alg.playing
      @finished = true
    else
      @move_animation = @alg.next_move().do(@pieces3d)
