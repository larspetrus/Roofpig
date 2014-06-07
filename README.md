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
<div class=roofpig style="width=140px; height=160px;"
  data-config="solved=UR-|colored=U U-|colors=F:B B:G U:R D:O R:W L:Y|alg=R U' F+B' R2 F'+B U' R'">
</div>
```

As you can see, the individual config properties are separated by |. Let's go over the different ones.

**Algorithms**

*Standard notation*

Roofpig supports (almost) all standard cube notation. 

Layer(s): F, B, R, L, U, D. M, E, S. x, y, z. Fw, Bw, Rw, Lw, Uw, Dw.

Turns: 2, ', 2'. You can also use ², Z, 1 and 3.


*Roofpig addons*

The standard slice and turn moves change the names of the cube sides. This is really impractical if you have a solution in FBRLUD and want to insert rotations to show off the interesting parts.

So Roofpig has "soft" rotations - which you can also think of as moving the "camera". R> rotates the whole cube the same way as an R move. R>> corresponds to R2, and R< and R<< to R' and RZ. Yes, F> is the same as B<.

Roofpig also allows combining moves. So you can do orientation safe slice moves like this: M = L'+R, E = D'+U and S = F'+B. And the 'w' moves like this: Rw = R>+L, Lw = L>+R, Uw = U>+D, Dw = D>+U, Fw=F>+B, Bw=B>+F

I could write much more, but trying things out in JSFiddle is probably more useful. Note that you can change the GTML and click Run to see what happens. Here: http://jsfiddle.net/Lar5/MfpVf/

**Defining the 'finished' state**

Typically an animated cube shows some moves solving the cube to a desired state.

The basic Roofpig usage is to define (1) that finished state, and (2) the moves to get there.

**Cubexp**

For many of the config parameters, we need to say which of the 54 stickers it applies to. For that task, I have developed a little shorthand language that is a bit similar to Regexps, but vastly less generic and scalable. 

