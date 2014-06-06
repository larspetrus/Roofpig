RoofPig
=======

Roofpig is an animated, programmable and interactive Rubik's Cube for the modern web. It uses WebGL or plain Canvas (by way of [three.js](http://threejs.org/)) and is written in CoffeeScript.

Usage
-----

Download the minified roofpig.js library and include it in your html.

The HEAD tag of your page should look like this:

```html
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="three.min.js"></script>
<script src="roofpig.min.js"></script>
```

A cube will then appear in all divs with class='roofpig' on that page.

```html
<div class=roofpig data-config="alg=R U R' U R U2 R'"></div>
```


**Dependencies**

Roofpig needs jQuery and three.js to work.


Configuration
-------------

Use data-config to configure the cube. Here is a full example:

```html
<div class=roofpig data-config="solved=UR-|colored=U U-|colors=F:B B:G U:R D:O R:W L:Y|alg=R U' F+B' R2 F'+B U' R'" style="width=140px; height=160px;"></div>
```

As you can see, the individual config properties are separated by |. Let's go over the different ones.

**Algorithms**

Roofpig supports most standard cube notation, and some inventions of its own.

*FBUDRL*

F, F', F2, B, B' B2, U, etc works like they should. F2 turns clockwise, F2' or FZ is F2 counter clockwise. You can also use F² for F2.

*Standard slices and turns*

The M, E, and S slice moves works, as do the x, y and z whole cube turns.

*Side name preserving slices and turns.*

The standard slices and turns change the names of the cube sides. If you want the red side to be "U" throughout, there are other ways.

Slice moves can be done by combining regular moves. So for M, use L'+R, E is D'+U and S is F'+B.

To display cube rotations - which you can also think of as moving the "camera" - there is some Roofpig specific notation: R> rotates the cube the same way as an R move, but moves the whole cube. R>> corresponds to R2, and R< and R<< to R' and RZ. This means F> is the same as B<.

Try it here: http://jsfiddle.net/Lar5/2xAVX/5/

**Defining the 'finished' state**

Typically an animated cube shows some moves solving the cube to a desired state.

The basic Roofpig usage is to define (1) that finished state, and (2) the moves to get there.

**Cubexp**

For many of the config parameters, we need to say which of the 54 stickers it applies to. For that task, I have developed a little shorthand language that is a bit similar to Regexps, but vastly less generic and scalable. 

