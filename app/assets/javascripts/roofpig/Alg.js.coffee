class @Alg
  constructor: ->
    @moves = [new Move(Side.F,1),new Move(Side.U,1),new Move(Side.F,3),new Move(Side.U,1),new Move(Side.F,1),new Move(Side.U,2),new Move(Side.F,3)]
    @next = 0

  next_move: ->
    move = @moves[@next]
    @next += 1
    return move