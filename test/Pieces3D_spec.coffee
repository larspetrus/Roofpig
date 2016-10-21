#= require three.min
#= require Pieces3D

mock_scene = { add: -> }

mock_colors = {
  to_draw: ->
    { hovers: true, color: 'red'}
  of: ->
    'black'
}
describe "Pieces3D", ->
  it ".make_stickers() creates Pieces3D.UBL, Pieces3D.UL, Pieces3D.F etc", ->
    pieces = new Pieces3D(mock_scene, 1, mock_colors)

    for piece in [pieces.UBL, pieces.UL, pieces.U]
      expect(piece).to.be.defined

    for piece in [pieces.BLU, pieces.WTF, pieces.LU]
      expect(piece).to.be.undefined

  describe "keeps track of pieces and stickers", ->
    it "for regular moves", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)

      expect(pieces.at.UFR.name).to.equal('UFR')
      expect(pieces.at.DR.name).to.equal('DR')
      expect(pieces.UFR.sticker_locations.join('')).to.equal('UFR')
      expect(pieces.DR.sticker_locations.join('')).to.equal('DR')

      pieces.move(Layer.R, 1)

      expect(pieces.at.UFR.name).to.equal('DFR') #The DFR piece is now in the UFR position
      expect(pieces.at.DR.name).to.equal('BR')
      expect(pieces.DFR.sticker_locations.join('')).to.equal('FUR') # The D sticker of the DFR piece is on the F side. F is on U. R is on R.
      expect(pieces.BR.sticker_locations.join('')).to.equal('DR')

      pieces.move(Layer.U, 2)

      expect(pieces.at.UFR.name).to.equal('UBL')
      expect(pieces.at.DR.name).to.equal('BR')
      expect(pieces.UBL.sticker_locations.join('')).to.equal('UFR')

    it "for slice moves", ->
      pieces = new Pieces3D(mock_scene, 1, mock_colors)

      pieces.move(Layer.M, 1)

      expect(pieces.at.UF.name).to.equal('UB')
      expect(pieces.at.U.name).to.equal('B')
      expect(pieces.UB.sticker_locations.join('')).to.equal('FU')
      expect(pieces.B.sticker_locations.join('')).to.equal('U')

      pieces.move(Layer.E, 2)

      expect(pieces.at.FR.name).to.equal('BL')
      expect(pieces.at.F.name).to.equal('D')
      expect(pieces.BL.sticker_locations.join('')).to.equal('FR')
      expect(pieces.U.sticker_locations.join('')).to.equal('B')

      expect(pieces.at.UFR.name).to.equal('UFR')

  it "#solved", ->
    solved = 'B BL BR D DB DBL DBR DF DFL DFR DL DR F FL FR L R U UB UBL UBR UF UFL UFR UL UR '

    pieces = new Pieces3D(mock_scene, 1, mock_colors)
    expect(pieces.state()).to.equal(solved)

    pieces.move(Layer.R, 2)
    pieces.move(Layer.R, -2)
    expect(pieces.state()).to.equal(solved)
