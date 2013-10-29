class @AlgAnimation
  constructor: (@alg) ->
    this._next_alg_move()

  animate: ->
    return if @finished

    if @move_animation.finished
      this._next_alg_move()

    @move_animation.animate()

  _next_alg_move: ->
    if @alg.at_end() || not @alg.playing
      @finished = true
    else
      @move_animation = @alg.next_move()
