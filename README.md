RoofPig
=======

Roofpig is an animated, programmable and interactive Rubik's Cube for the modern web. It uses WebGL or plain Canvas (by way of [three.js](http://threejs.org/)) and is written in CoffeeScript.

Usage
-----

Download the minified roofpig.js library and include it in your html. Alternatively hotlink it from Github.

The HEAD tag of your page should look like this:

```html
  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
  <script src="three.min.js"></script>
  <script src="roofpig.js"></script>
```

To make a cube appear, put a div with the class 'roofpig' on the page:

```html
  <div class=roofpig data-config="alg=R U R' U R U2 R'"></div>
```


**Dependencies**

Roofpig very much needs jQuery and three.js to work!


Configuration
-------------

**Defining the 'finished' state**

Typically an animated cube shows some moves solving the cube to a desired state.

The basic Roofpig usage is to (1) define that 'finished' state, and (2) the moves to get there.

**Cubexp**

For many of the config parameters, we need to say which of the 54 stickers it applies to. For that task, I have developed a little shorthand language that is a bit similar to Regexps, but vastly less generic and scalable. 

