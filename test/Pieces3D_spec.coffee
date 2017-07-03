#= require three.min
#= require Pieces3D

mock_scene = { add: -> }

mock_colors = {
  to_draw: ->
    { hovers: true, color: 'red'}
  of: ->
    'black'
}

make_moves = (pieces, moves) ->
  for move in moves.split(' ')
    [layer, turns, is_rotation] = Move.parse_code(move)
    pieces.move(layer, turns)

describe "Pieces3D", ->
  it "constructor creates Pieces3D.UBL, Pieces3D.UL, Pieces3D.F etc", ->
    pieces = new Pieces3D(mock_scene, 1, mock_colors)

    for piece in [pieces.UBL, pieces.UL, pieces.U]
      expect(piece).to.be.defined

    for piece in [pieces.BLU, pieces.WTF, pieces.LU]
      expect(piece).to.be.undefined

  describe "#move tracks pieces and stickers", ->
    it "B move", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      pieces.move(Layer.B, 1)

      expect(pieces.at.UB.name).to.equal('BR')
      expect(pieces.BR.sticker_locations.join('')).to.equal('BU')
      expect(pieces.UB.sticker_locations.join('')).to.equal('LB')

    it "R move", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      pieces.move(Layer.R, 1)

      expect(pieces.at.DR.name).to.equal('BR')
      expect(pieces.BR.sticker_locations.join('')).to.equal('DR')
      expect(pieces.DR.sticker_locations.join('')).to.equal('FR')

    it "D move", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      pieces.move(Layer.D, 1)

      expect(pieces.at.DF.name).to.equal('DL')
      expect(pieces.DL.sticker_locations.join('')).to.equal('DF')
      expect(pieces.DF.sticker_locations.join('')).to.equal('DR')

    it "F move", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      pieces.move(Layer.F, 1)

      expect(pieces.at.FL.name).to.equal('DF')
      expect(pieces.DF.sticker_locations.join('')).to.equal('LF')
      expect(pieces.FL.sticker_locations.join('')).to.equal('FU')

    it "L move", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      pieces.move(Layer.L, 1)

      expect(pieces.at.DL.name).to.equal('FL')
      expect(pieces.FL.sticker_locations.join('')).to.equal('DL')
      expect(pieces.DL.sticker_locations.join('')).to.equal('BL')

    it "U move", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      pieces.move(Layer.U, 1)

      expect(pieces.at.UF.name).to.equal('UR')
      expect(pieces.UR.sticker_locations.join('')).to.equal('UF')
      expect(pieces.UF.sticker_locations.join('')).to.equal('UL')

    it "M move", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      pieces.move(Layer.M, 1)

      expect(pieces.at.UF.name).to.equal('UB')
      expect(pieces.UB.sticker_locations.join('')).to.equal('FU')
      expect(pieces.UF.sticker_locations.join('')).to.equal('FD')

    it "E move", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      pieces.move(Layer.E, 1)

      expect(pieces.at.FR.name).to.equal('FL')
      expect(pieces.FL.sticker_locations.join('')).to.equal('RF')
      expect(pieces.FR.sticker_locations.join('')).to.equal('RB')

    it "S move", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      pieces.move(Layer.S, 1)

      expect(pieces.at.UL.name).to.equal('DL')
      expect(pieces.DL.sticker_locations.join('')).to.equal('LU')
      expect(pieces.UL.sticker_locations.join('')).to.equal('RU')

    it "many random moves", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)

      make_moves(pieces, "M' B' U R' S2 M2 L D F E' R2 D2 B2 R L2 E2 B U2 D' F' S F2 L' U'")

      # check that the sticker tracking matches the piece tracking
      for name in ['B','BL','BR','D','DB','DBL','DBR','DF','DFL','DFR','DL','DR','F','FL','FR','L','R','U','UB','UBL','UBR','UF','UFL','UFR','UL','UR']
        expect(name.split('').sort().join('')).to.equal(pieces.at[name].sticker_locations.sort().join(''))


  describe "#solved", ->
    it "simple cases", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      expect(pieces.solved()).to.equal(true)

      pieces.move(Layer.R, 2)
      expect(pieces.solved()).to.equal(false)

      pieces.move(Layer.R, -2)
      expect(pieces.solved()).to.equal(true)


    it "works in different orientation", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)
      expect(pieces.solved(), 1).to.equal(true)

      pieces.move(Layer.F, 1)
      expect(pieces.solved(), 2).to.equal(false)
      pieces.move(Layer.S, 1)
      expect(pieces.solved(), 3).to.equal(false)
      pieces.move(Layer.B, 3)
      expect(pieces.solved(), 4).to.equal(true)

      make_moves(pieces, "F S B'")
      expect(pieces.solved(), 5).to.equal(true)

      make_moves(pieces, "F S B'")
      expect(pieces.solved(), 6).to.equal(true)

      make_moves(pieces, "R M' L'")
      expect(pieces.solved(), 7).to.equal(true)


