class @AlgAnimation
  constructor: (@alg) ->
    this._next_alg_move()

  animate: ->
    return if @finished

    if @move_animation.finished
      this._next_alg_move()

    @move_animation.animate()

  _next_alg_move: ->
    move = @alg.next_move()
    if move
      @move_animation = move.start_animation()
    else
      @finished = true
