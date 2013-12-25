#= require three.min
#= require roofpig/Pieces3D

mock_scene    = { add: -> }

mock_settings = {
  hover: 1.0,
  colors: {
    to_draw: -> { hovers: true, color: 'red'}
    of: -> 'black'
  }
}
describe "Pieces3D", ->
  it ".make_stickers() creates Pieces3D.UBL, Pieces3D.UL, Pieces3D.F etc", ->
    pieces = new Pieces3D(mock_scene, mock_settings)

    for piece in [pieces.UBL, pieces.UL, pieces.U]
      expect(piece).to.be.defined

    for piece in [pieces.BLU, pieces.WTF, pieces.LU]
      expect(piece).to.be.undefined
