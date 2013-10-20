#= require roofpig/Pieces3D

class @Positions

  @init: ->
    @at =
      UFR: Pieces3D.map.UFR
      UFL: Pieces3D.map.UFL
      UBR: Pieces3D.map.UBR
      UBL: Pieces3D.map.UBL
      DFR: Pieces3D.map.DFR
      DFL: Pieces3D.map.DFL
      DBR: Pieces3D.map.DBR
      DBL: Pieces3D.map.DBL
      UF: Pieces3D.map.UF
      UB: Pieces3D.map.UB
      UL: Pieces3D.map.UL
      UR: Pieces3D.map.UR
      DF: Pieces3D.map.DF
      DB: Pieces3D.map.DB
      DL: Pieces3D.map.DL
      DR: Pieces3D.map.DR
      FR: Pieces3D.map.FR
      FL: Pieces3D.map.FL
      BR: Pieces3D.map.BR
      BL: Pieces3D.map.BL


  @for_u: -> [@at.UFR, @at.UFL, @at.UBR, @at.UBL, @at.UF, @at.UB, @at.UL, @at.UR, Pieces3D.map.U]
  @for_d: -> [@at.DFR, @at.DFL, @at.DBR, @at.DBL, @at.DF, @at.DB, @at.DL, @at.DR, Pieces3D.map.D]
  @for_f: -> [@at.UFL, @at.UFR, @at.DFR, @at.DFL, @at.UF, @at.FR, @at.DF, @at.FL, Pieces3D.map.F]
  @for_b: -> [@at.UBL, @at.UBR, @at.DBR, @at.DBL, @at.UB, @at.BR, @at.DB, @at.BL, Pieces3D.map.B]
  @for_l: -> [@at.UFL, @at.DFL, @at.DBL, @at.UBL, @at.UL, @at.FL, @at.DL, @at.BL, Pieces3D.map.L]
  @for_r: -> [@at.UFR, @at.DFR, @at.DBR, @at.UBR, @at.UR, @at.FR, @at.DR, @at.BR, Pieces3D.map.R]

  @for_side: (side_char) ->
    return this.for_u() if side_char == 'U'
    return this.for_d() if side_char == 'D'
    return this.for_f() if side_char == 'F'
    return this.for_b() if side_char == 'B'
    return this.for_l() if side_char == 'L'
    return this.for_r() if side_char == 'R'

  @u_move: (turns) ->
    for n in [1..turns]
      this._permute('UBR', 'UBL', 'UFL', 'UFR')
      this._permute('UR', 'UB', 'UL', 'UF')

  @d_move: (turns) ->
    for n in [1..turns]
      this._permute('DFR', 'DFL', 'DBL', 'DBR')
      this._permute('DF', 'DL', 'DB', 'DR')

  @f_move: (turns) ->
    for n in [1..turns]
      this._permute('DFL', 'DFR', 'UFR', 'UFL')
      this._permute('FL',  'DF',  'FR',  'UF')

  @b_move: (turns) ->
    for n in [1..turns]
      this._permute('UBL', 'UBR', 'DBR', 'DBL')
      this._permute('UB', 'BR', 'DB', 'BL')

  @l_move: (turns) ->
    for n in [1..turns]
      this._permute('UBL', 'DBL', 'DFL', 'UFL')
      this._permute('BL', 'DL', 'FL', 'UL')

  @r_move: (turns) ->
    for n in [1..turns]
      this._permute('UFR', 'DFR', 'DBR', 'UBR')
      this._permute('UR', 'FR', 'DR', 'BR')

  @_permute: (p1, p2, p3, p4) ->
    [@at[p1], @at[p2], @at[p3], @at[p4]] = [@at[p2], @at[p3], @at[p4], @at[p1]]

  @print: ->
    msg = "PRINT:UFR:#{@at.UFR.name} UFL:#{@at.UFL.name} UBR:#{@at.UBR.name} UBL:#{@at.UBL.name} DFR:#{@at.DFR.name} DFL:#{@at.DFL.name} DBR:#{@at.DBR.name} DBL:#{@at.DBL.name} UF:#{@at.UF.name} UB:#{@at.UB.name} UL:#{@at.UL.name} UR:#{@at.UR.name} DF:#{@at.DF.name} DB:#{@at.DB.name} DL:#{@at.DL.name} DR#{@at.DR.name} FR:#{@at.FR.name} FL:#{@at.FL.name} BR:#{@at.BR.name} BL:#{@at.BL.name}"
    console.log(msg)
