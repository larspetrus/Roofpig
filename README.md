# Roofpig

Roofpig is an animated, programmable and interactive Rubik's Cube for the modern web. It uses WebGL or plain Canvas (by way of [three.js](http://threejs.org/)) and is written in CoffeeScript. You can see it in use on http://lar5.com/cube/, or [play with demos](http://jsfiddle.net/Lar5/86L4C/). 

It should work on most [any modern browser](http://caniuse.com/canvas).

## 1. Usage
All you need is one file and a web server. Put [`roofpig_and_three.min.js`](https://raw.githubusercontent.com/dunkelziffer/Roofpig/development/roofpig_and_three.min.js) on your server. Include it, and jQuery 3.1.1 in your HTML:

```html
<script src="http://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="roofpig_and_three.min.js"></script>
```
##### Static creation
To put a cube on the page, make a `div` with `class='roofpig'`. Configuration goes in a `data-config` attribute. Set height and width in CSS. **That's it!**

```html
<div class=roofpig data-config="alg=R U R' U R U2 R'"></div>
```

##### Dynamic creation
To create a cube dynamically under a parent div, call `CubeAnimation.create_in_dom(parent_div, config, div_attributes)`, where `config` is the  `data-config` and `div_attributes` is what it sounds like.
```html
CubeAnimation.create_in_dom('#show-alg', "alg=R U R' U R U2 R'", "class='my-roofpig'");
```


## 2. data-config
In `data-config` you set values to properties. The format is `property1=value|prop2=other value|prop99=you get the idea`.

This is a fully configured example cube:

```html
<div class=roofpig style="width:140px; height:160px;"
  data-config="alg=L' U2 L U2 R U' L' U L+R'|solved=U-/ce|colors=F:b B:g U:r D:o R:w L:y">
</div>
```

Valid properties are: `alg`, `algdisplay`, `base`, `colored`, `colors`, `flags`, `hover`, `pov`, `setup`, `solved`, `speed`, `tweaks`. We'll go over them in a logical order.

### 2.1 The Algorithm. `alg`.
Define the animated algorithm like this: `alg=R F' x2 R D Lw'`. It handles standard cube notation and some more. If no alg is given, the playback buttons don't appear.

##### Standard notation
Roofpig supports (almost) all standard cube notation. Layer(s): **F, B, R, L, U, D. M, E, S. x, y, z. Fw, Bw, Rw, Lw, Uw, Dw, f, b, r, l, u, d**. Turns: **2, ', 2'**. You can also use **², Z, 1**, and **3**.


##### Rotation notation
Roofpig adds "non destructive" rotations, that turns the cube while preserving the side names (in contrast, inserting `x2` changes all following moves). You can think of them as moving the "camera". `R>` rotates the whole cube like an `R` move. `R>>` is a double turn, `R<` and `R<<` the same in the opposite direction. This means `F>` is the same as `B<`.

##### Combination notation
Roofpig also allows combining moves. Using **+**. Side safe slice moves: `M` = `L'+R`, `E` = `D'+U`, and `S` = `F'+B`. 'w' moves: `Rw` = `R>+L`, `Lw` = `L>+R`, `Uw` = `U>+D`, etc. Whole cube: `y`=`U+E'+D'`. Combining moves that can't be done in parallel, like `L+U` or `Rw+Fw2`, will make horrible and amusing things happen.

[**Alg notation demo**](http://jsfiddle.net/Lar5/MfpVf/)

### 2.2 The Cube
In Roofpig, you normally define how the cube will look after the alg is done. By default, it's a fully colored cube. You can also make parts 'solved' (dark gray) or 'ignored' (light gray), move pieces, recolor stickers and sprinkle out **X**-es.

But first we must talk about Cubexps.

##### Cubexps
We often need to define sets of stickers. So I made a tiny language to simply describe groups of stickers.

Cubexps do one thing: Define a set stickers, out of the 54 on a cube. That's it. They do nothing else.

The simplest format is listing pieces. `UBL` is all the stickers on the UBL corner piece. `F` is the F side center sticker. This Cubexp is the whole U layer: `U UB UBL UBR UF UFL UFR UL UR`. For individual stickers, `UbL` is only the U and L stickers on UBL. So `U Ub Ubl Ubr Uf Ufl Ufr Ul Ur` is the U *side*.

This would be enough to define any set of stickers. It would also be tedious to write and hard to read. So there are shorthand expressions.

- __F*__. Whole layer(s). `U*` is the U layer (`U UB UBL UBR UF UFL UFR UL UR`). `UF*` is the whole U and F layers.
- __F-__. Everything *not* in these layers. `U-` is everything but the U layer. `ULB-` is the pieces not in U, L or B, which are `D DF DFR DR F FR R` (the DFR 2x2x2 block).
- __f__. A whole *side*. `u` is the same as `U Ub Ubl Ubr Uf Ufl Ufr Ul Ur`.
- __*__. The whole cube. Useful for filtering (see below)
- __Filtering__. All expressions can be filtered by piece types. `c` = corners, `e` = edges and `m` = 'middles'. So `U*/c` is the corners in the U layer, or `UBL UBR UFL UFR`. `u/me` is `U Ub Uf Ul Ur`. The demo has more.

[**Cubexp demo**](http://jsfiddle.net/Lar5/2xAVX/)

Now that we know Cubexps, we can make cubes!

##### `solved` and `colored`
The main parameters for this are the `solved` and `colored` Cubexps. `solved` stickers will be dark grey. `colored` stickers will have normal colors. Anything not `solved` or `colored` will be light gray as 'ignored'. `solved` trumps `colored`.

[**`Solved` and `colored` demo**](http://jsfiddle.net/Lar5/tE83s/)

##### `setupmoves` and `tweaks`
When marking stickers 'solved' and 'ignored' is not enough, you need to use these.

- `setupmoves` applies some moves to the cube. For example `setupmoves=L' B' R B L B' R' B` permutes 3 corners.
- `tweaks` is the free form tool, that can set any sticker to any color - AND MORE! `tweaks=F:RF` sets both stickers on the FR edge to the F color. `tweaks=R:Ubl` sets only the U sticker on the UBL corner to the R color.
Aside from colors, you can also put **X** es on stickers: `tweaks=X:Ub x:Ul`

[`setupmoves` and `tweaks` demo](http://jsfiddle.net/Lar5/JFgQg/) (clearer than the text)

### 2.3 Other parameters

[**Other parameters Demo**](http://jsfiddle.net/Lar5/9vq68/)

##### `hover`
How far out do the 'peek' stickers hover away from the cube? `1` is 'not at all'. `10` is 'too far'. It's easiest to use the aliases `none`, `near` and `far` (1, 2 and 7.1). Solved and ignored stickers don't hover.

##### `speed`
Number of milliseconds for a turn. Defaults to 400. Double turns take 1.5x longer.

##### `flags`
Things that can only be on or off are set to "ON" by mentioning them in this free form text field. Current flags are 
- `showalg` - Display the alg, according to the `algdisplay` setting.
- `canvas` - Use regular 2D canvas to draw instead of WebGL.
- `startsolved` - Start out with a solved cube, instead of with the reverse alg applied.

##### `colors`
Default colors are **R** - green, **L** - blue, **F** - red, **B** - orange, **U** - yellow, and **D** - white. Or `colors=R:g L:b F:r B:o U:y D:w` in this notation. Aside from 'g' for green etc, you can also use any CSS color, like `pink`, `#77f`, `#3d3dff` etc.

##### `pov`
By default the Point Of View is on the UFR corner, with U on top. Or `Ufr` in this notation. To face DFL with F on top, use `pov=Fdl`.

##### `algdisplay`
This defines how algs are written (if `showalg` is on). Much like flags, it's a free form string, where we look for certain words:
- `fancy2s` - Double moves are written F² rather than F2.
- `rotations` - Displays the Roofpig rotations (R>, U<< etc) . Off by default.
- `2p` - Display counter clockwise double moves as 2'. Just 2 by default.
- `Z` - Display counter clockwise double moves as Z.


### 2.4 `base` - sharing configs.
By now you may be asking, "But Lars, what if I use the Japanese color scheme? Do I really have to repeat that in each and every cube config?". To that I say, "No, dear infomercial plant, Roofpig has a simple way to share common config, which both cuts down on repetition and makes the common parts easy and safe to change!"

You can use Javascript variables, named starting with **"ROOFPIG_CONF_"**, as base.

```html
<script>
  ROOFPIG_CONF_F5 = "solved=U- | colors=F:B B:G U:R D:O R:W L:Y"
</script>
<div class=roofpig data-config="base=F5|alg=L+R' U' R U L' U' R' U R"></div>
<div class=roofpig data-config="base=F5|alg=R' U' R U L U' R' U R+L'"></div>
```

Properties in data-config override those "inherited" from the base. One `base` can refer to another `base` to form an elaborate hierarchy if you're into that kind of complexity.

To share between pages, you can for example put **"ROOFPIG_CONF_"**'s in a common .js file.

### 3. Working with the code
1. Install Node and NPM - https://docs.npmjs.com/getting-started/installing-node
2. Install nvm - https://github.com/nvm-sh/nvm
3. Clone/download this Github repository, and `cd` to the resulting directory
4. `nvm install lts/gallium`
5. `nvm use`
6. `npm install`
7. `sudo npm install -g gulp`

Now the gulp task below should work. Let me know if it doesn't.

#### Running the prebuilt release version

The `demo.html` in the root directory shows multiple examples using the current release version.

#### Building it

Running `gulp build` or simply `gulp` on the command line creates a `roofpig_and_three.min.js` and a `local_demo.html` file in `local/build/`.

#### Testing it

Running `gulp test` creates everything needed for testing in `local/test/`. Open `mocha.html` in a browser to run the tests suite.


## 4. What's a Roofpig anyway?
[**"Most unexpected!"**](https://www.youtube.com/watch?v=PtO0diaiZEE&t=14m57s)
