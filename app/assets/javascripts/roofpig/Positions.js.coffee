#= require roofpig/Pieces3D

class @Positions

  @init: ->
    @at =
      UFR: Pieces3D.UFR
      UFL: Pieces3D.UFL
      UBR: Pieces3D.UBR
      UBL: Pieces3D.UBL
      DFR: Pieces3D.DFR
      DFL: Pieces3D.DFL
      DBR: Pieces3D.DBR
      DBL: Pieces3D.DBL
      UF: Pieces3D.UF
      UB: Pieces3D.UB
      UL: Pieces3D.UL
      UR: Pieces3D.UR
      DF: Pieces3D.DF
      DB: Pieces3D.DB
      DL: Pieces3D.DL
      DR: Pieces3D.DR
      FR: Pieces3D.FR
      FL: Pieces3D.FL
      BR: Pieces3D.BR
      BL: Pieces3D.BL


  @for_side: (side) ->
    return [@at.UFR, @at.UFL, @at.UBR, @at.UBL, @at.UF, @at.UB, @at.UL, @at.UR, Pieces3D.U]  if side == Side.U
    return [@at.DFR, @at.DFL, @at.DBR, @at.DBL, @at.DF, @at.DB, @at.DL, @at.DR, Pieces3D.D]  if side == Side.D
    return [@at.UFL, @at.UFR, @at.DFR, @at.DFL, @at.UF, @at.FR, @at.DF, @at.FL, Pieces3D.F]  if side == Side.F
    return [@at.UBL, @at.UBR, @at.DBR, @at.DBL, @at.UB, @at.BR, @at.DB, @at.BL, Pieces3D.B]  if side == Side.B
    return [@at.UFL, @at.DFL, @at.DBL, @at.UBL, @at.UL, @at.FL, @at.DL, @at.BL, Pieces3D.L]  if side == Side.L
    return [@at.UFR, @at.DFR, @at.DBR, @at.UBR, @at.UR, @at.FR, @at.DR, @at.BR, Pieces3D.R]  if side == Side.R

  @move_pieces: (side, turns) ->
    this._move(turns, ['UBR', 'UBL', 'UFL', 'UFR'], ['UR', 'UB', 'UL', 'UF'])  if side == Side.U
    this._move(turns, ['DFR', 'DFL', 'DBL', 'DBR'], ['DF', 'DL', 'DB', 'DR'])  if side == Side.D
    this._move(turns, ['DFL', 'DFR', 'UFR', 'UFL'], ['FL', 'DF', 'FR', 'UF'])  if side == Side.F
    this._move(turns, ['UBL', 'UBR', 'DBR', 'DBL'], ['UB', 'BR', 'DB', 'BL'])  if side == Side.B
    this._move(turns, ['UBL', 'DBL', 'DFL', 'UFL'], ['BL', 'DL', 'FL', 'UL'])  if side == Side.L
    this._move(turns, ['UFR', 'DFR', 'DBR', 'UBR'], ['UR', 'FR', 'DR', 'BR'])  if side == Side.R

  @_move: (turns, corners, edges) ->
    for n in [1..turns]
      this._permute(corners)
      this._permute(edges)

  @_permute: (p) ->
    [@at[p[0]], @at[p[1]], @at[p[2]], @at[p[3]]] = [@at[p[1]], @at[p[2]], @at[p[3]], @at[p[0]]]
