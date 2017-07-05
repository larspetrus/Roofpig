# Move utility functions

class Move

  turn_code_pairs = {'-2': ['Z', '2'], '-1': ["'", ''], 1: ['', "'"], 2: ['2', 'Z']}
  @make: (code, world3d, speed) ->
    if code.indexOf('+') > -1
      new CompositeMove(code, world3d, speed)

    else if code[0] in ['x', 'y', 'z']
      [t1, t2] = turn_code_pairs[Move.parse_turns(code.substring(1))]
      moves = switch code[0]
        when 'x' then "R#{t1}+M#{t2}+L#{t2}"
        when 'y' then "U#{t1}+E#{t2}+D#{t2}"
        when 'z' then "F#{t1}+S#{t1}+B#{t2}"
      new CompositeMove(moves, world3d, speed, code)

    else
      last_char_index = 2 if (code[1] == 'w' && code[0] in ['U', 'D', 'L', 'R', 'F', 'B'])
      last_char_index = 1 if (code[0] in ['u', 'd', 'l', 'r', 'f', 'b'])
      if last_char_index
        [t1, t2] = turn_code_pairs[Move.parse_turns(code.substring(last_char_index))]
        moves = switch code[0].toUpperCase()
          when 'R' then "R#{t1}+M#{t2}"
          when 'L' then "L#{t1}+M#{t1}"
          when 'U' then "U#{t1}+E#{t2}"
          when 'D' then "D#{t1}+E#{t1}"
          when 'F' then "F#{t1}+S#{t1}"
          when 'B' then "B#{t1}+S#{t2}"
        new CompositeMove(moves, world3d, speed, code)

      else
        new SingleMove(code, world3d, speed)

  @parse_code: (code) ->
    turns = Move.parse_turns(code.substring(1))
    is_rotation = code.substring(1) in [">", ">>", "<", "<<"]
    layer = Layer.by_name(code[0])

    unless layer && turns
      throw new Error("Invalid Move code '#{code}'")
    [layer, turns, is_rotation]

  @parse_turns: (turn_code) ->
    switch turn_code
      when "1",  "", ">" then  1
      when "2", "²",">>" then  2
      when "3", "'", "<" then -1
      when "Z","2'","<<" then -2

  @turn_code: (turns, rotation = false) ->
    { true: { 1: '>', 2: '>>', '-1': '<', '-2': '<<'}, false: { 1: '', 2: '2', '-1': "'", '-2': 'Z'}}[rotation][turns]

  @displayify: (move_text, algdisplay) ->
    result = move_text.replace('Z', algdisplay.Zcode)
    result = result.replace('2', '²') if algdisplay.fancy2s
    result

  HUMAN_NAMES = {
    "F2+S2+BZ": "z2",
    "F+S+B'":   "z",
    "F'+S'+B":  "z'",
    "U2+EZ+DZ": "y2",
    "U+E'+D'":  "y",
    "U'+E+D":   "y'",
    "R2+MZ+LZ": "x2",
    "R+M'+L'":  "x",
    "R'+M+L":   "x'",
  }
  @human_name: (primitive_name) ->

    HUMAN_NAMES[primitive_name] || primitive_name