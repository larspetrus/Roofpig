class @AlgAnimation
  constructor: (@alg, @display) ->
    this._next_alg_move()

  animate: ->
    return if @finished

    if @move_animation.finished
      this._next_alg_move()

    if @move_animation
      @move_animation.animate()

  _next_alg_move: ->
    if @alg.playing
      @move_animation = @alg.next_move(@display)
    @finished = not @alg.playing
