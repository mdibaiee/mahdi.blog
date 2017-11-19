---
layout: post
title:  "Mathematical Induction for proving tiling methods"
date:   2017-10-19
permalink: mathematical-induction-proving-tiling-methods/
categories: math
math: true
author: Mahdi
---

On my way towards self-taught data science, I've stumbled upon the need to be proficient with mathematical proofs, so I picked up the amazing [How To Prove It: A Structured Approach](https://www.amazon.com/How-Prove-It-Structured-Approach/dp/0521675995) by Daniel J. Velleman; and I've been fascinated by mathematical proofs since then.

One of the uses for [Mathematical Induction](https://en.wikipedia.org/wiki/Mathematical_induction) which I've found to be pretty cool is proving methods for tiling shapes.

Here is an example:

Suppose $n$ is a positive integer. An equilateral triangle is cut into $4^n$ congruent equilateral triangles, and one corner is removed. Show that the remaining area can be covered by trapezoidal tiles like this: <img src='/img/tiling/trapezoidal.jpg' class='inline' width='30'/>

<canvas id='tiling-triangle' width='200' height='200' class='centered'></canvas>
{% include caption.html text='An example of n = 2. The dark tile is removed.' %}

Just to be clear, by _cover_ we mean covering without any overlaps, so you can't have two overlapping trapezoidal tiles.

As with any mathematical induction solution, we start with the base case, which is $n = 1$, in that case the triangle looks like this:

<canvas id='base-case' width='100' height='100' class='centered'></canvas>

In this case, it's obvious that we can cover the leftover area using trapezoidal tiles consisting of three equilateral triangles (the second row), so:

----

Base case: $n = 1$ then the triangle has $4^1 = 4$ tiles, and by removing the top-most tile, the second row can be covered using a single trapezoidal tile. 

----

Now for the induction step, we have to somehow show that after adding 1 to $n$, that is, by multiplying the tiles by $4$, we can still cover the triangle by trapezoidal tiles. To show this, we start by assuming we have a triangle with $4^n$ tiles, which we know can be covered by trapezoidal tiles, then we add the new tiles and show that they, too, can be covered by trapezoidal tiles.

----

Induction Step: Suppose we have a triangle split into $4^n$ tiles, and we know by induction hypothesis that it can be covered by trapezoidal tiles. Now suppose we have another triangle with $4^{n+1}$ tiles, that means, $4$ times as many triangles as our original triangle. We can then group the new bigger triangle into 4 congruent triangles, one of which we know can be split into trapezoidal tiles by removing one of it's tiles. For the three left triangles, we can find a neighbouring corner and assume the tile on that corner to be removed, and then cover the rest by trapezoidal tiles. Afterwards, since we had three such corners, and they are neighbouring corners, we can cover these three corners with one trapezoidal tile, thus completing the triangle.

----

Now that's a mouthful, in simpler terms, we are following these steps (for $n = 2$):

<canvas id='n-2' width='200' height='200' class='centered'></canvas>

First, we split the whole triangle into 4 smaller groups:

<canvas id='n-2-grouped' width='200' height='200' class='centered'></canvas>

Then, we know that one of the triangles can be covered by trapezoidal tiles if we remove one of it's tiles, that's the induction hypothesis (the case for $4^n$ which is proved in the base case):

<canvas id='n-2-grouped-removed' width='200' height='200' class='centered'></canvas>

Leaving the top triangle behind, we now find neighbouring corners among the three left triangles, and we assume the tiles in those corners to be removed (they are not actually removed as we are constrained to remove only one tile):

<canvas id='n-2-grouped-neighbours' width='200' height='200' class='centered'></canvas>

Now we can cover the rest of these triangles by a single trapezoidal tile, similar to the case of $n = 1$.

Afterwards, we see that the three neighbouring tiles form a trapezoidal tile, therefore we can now put the last piece there to complete the tiles.

<canvas id='final' width='200' height='200' class='centered'></canvas>

This procedure can be applied recursively on larger values of $n$ as well, so this concludes a proof of tiling an equilateral triangle divided into $4^n$ equilateral triangles using trapezoidal tiles after removing a single piece.

<script>
  (function() {
    var tilingTriangle = document.getElementById('tiling-triangle');
    var c = tilingTriangle.getContext('2d');
    
    function TriangleCanvas(id) {
      this.element = document.getElementById(id);
      this.context = this.element.getContext('2d');
    }

    function modifyColor(c, p) {
      var e = document.createElement('i');
      e.style.background = c;
      var r = getComputedStyle(e).backgroundColor.slice(4, -1).split(',').map(parseFloat);
      return 'rgb(' + [r[0] + p, r[1] + p, r[2] + p].join(',') + ')';
    }

    function dedup(list) {
      return list.reduce(function(newList, item) {
        if (!newList.some(function(a) { return deepCompare(a, item) })) {
          return newList.concat(item);
        }
        return newList;
      }, []);
    }

    function deepCompare () {
      var i, l, leftChain, rightChain;

      function compare2Objects (x, y) {
        var p;

        // remember that NaN === NaN returns false
        // and isNaN(undefined) returns true
        if (isNaN(x) && isNaN(y) && typeof x === 'number' && typeof y === 'number') {
            return true;
        }

        // Compare primitives and functions.     
        // Check if both arguments link to the same object.
        // Especially useful on the step where we compare prototypes
        if (x === y) {
            return true;
        }

        // Works in case when functions are created in constructor.
        // Comparing dates is a common scenario. Another built-ins?
        // We can even handle functions passed across iframes
        if ((typeof x === 'function' && typeof y === 'function') ||
          (x instanceof Date && y instanceof Date) ||
          (x instanceof RegExp && y instanceof RegExp) ||
          (x instanceof String && y instanceof String) ||
          (x instanceof Number && y instanceof Number)) {
            return x.toString() === y.toString();
        }

        // At last checking prototypes as good as we can
        if (!(x instanceof Object && y instanceof Object)) {
            return false;
        }

        if (x.isPrototypeOf(y) || y.isPrototypeOf(x)) {
            return false;
        }

        if (x.constructor !== y.constructor) {
            return false;
        }

        if (x.prototype !== y.prototype) {
            return false;
        }

        // Check for infinitive linking loops
        if (leftChain.indexOf(x) > -1 || rightChain.indexOf(y) > -1) {
            return false;
        }

        // Quick checking of one object being a subset of another.
        // todo: cache the structure of arguments[0] for performance
        for (p in y) {
            if (y.hasOwnProperty(p) !== x.hasOwnProperty(p)) {
                return false;
            }
            else if (typeof y[p] !== typeof x[p]) {
                return false;
            }
        }

        for (p in x) {
            if (y.hasOwnProperty(p) !== x.hasOwnProperty(p)) {
                return false;
            }
            else if (typeof y[p] !== typeof x[p]) {
                return false;
            }

            switch (typeof (x[p])) {
                case 'object':
                case 'function':

                    leftChain.push(x);
                    rightChain.push(y);

                    if (!compare2Objects (x[p], y[p])) {
                        return false;
                    }

                    leftChain.pop();
                    rightChain.pop();
                    break;

                default:
                    if (x[p] !== y[p]) {
                        return false;
                    }
                    break;
            }
        }

        return true;
      }

      if (arguments.length < 1) {
        return true; //Die silently? Don't know how to handle such case, please help...
        // throw "Need two or more arguments to compare";
      }

      for (i = 1, l = arguments.length; i < l; i++) {

          leftChain = []; //Todo: this can be cached
          rightChain = [];

          if (!compare2Objects(arguments[0], arguments[i])) {
              return false;
          }
      }

      return true;
    }

    TriangleCanvas.prototype.drawTriangle = function(x, y, size, fill, reversed) {
      var c = this.context;
      var corners = [{
        x: x,
        y: y,
      }, {
        x: x - size / 2,
        y: y + size,
      }, {
        x: x + size / 2,
        y: y + size,
      }];

      if (reversed) {
        corners = [{
          x: x + size / 2,
          y: y,
        }, {
          x: x - size / 2,
          y: y,
        }, {
          x: x,
          y: y + size
        }];
      }

      if (fill) {
        this.drawShape(corners, modifyColor(fill, 20), fill);
      } else {
        this.drawShape(corners);
      }
    }

    TriangleCanvas.prototype.drawTrapezoid = function(tiles, size, strokeStyle, fillStyle) {
      var corners = tiles
                    .map(function(o) {
                      return { x: o[0] * size, y: o[1] * size };
                    });

      console.log(corners);

      this.drawShape(corners, strokeStyle, fillStyle);
    }

    TriangleCanvas.prototype.drawShape = function(corners, strokeStyle, fillStyle) {
      var c = this.context;
      c.beginPath();

      c.moveTo(corners[0].x, corners[0].y);
      corners.slice(1).concat([corners[0]]).forEach(function(object, index) {
        c.lineTo(object.x, object.y);
      }); 

      c.closePath();
      if (fillStyle) {
        c.fillStyle = fillStyle;
        c.fill();
      }
      if (strokeStyle) c.strokeStyle = strokeStyle;
      c.stroke();
    }

    TriangleCanvas.prototype.drawSplittedTriangle = function(x, y, size, split, blocks, rest) {
      var c = this.context;

      var rows = Math.sqrt(split);
      var rowHeight = size / rows;
      var triangleSize = size / rows;

      for (var i = 0; i < rows * 2; i += 2) {
        var row = Math.floor(i / 2);

        for (var j = 0; j < i + 1; j++) {
          var position = {
            x: x + triangleSize * j / 2 - (row * triangleSize / 2),
            y: y + row * rowHeight,
          };

          var block = blocks.reduce(function(c, a) {
            return (a[0] === row && a[1] === j) ? (a[2] || 'black') : c;
          }, null);

          this.drawTriangle(position.x, position.y, triangleSize, block || rest, j % 2 == 1);
        }
      }
    }
    
    var c1 = new TriangleCanvas('tiling-triangle');
    c1.drawSplittedTriangle(100, 0, 200, Math.pow(4, 2), [[0, 0, '#435062']], '#92afd7');

    var c2 = new TriangleCanvas('base-case');
    c2.drawSplittedTriangle(50, 0, 100, 4, [[0, 0, '#435062']], '#92afd7');

    var c3 = new TriangleCanvas('n-2');
    c3.drawSplittedTriangle(100, 0, 200, Math.pow(4, 2), [[0, 0, '#435062']], '#92afd7');

    var c4 = new TriangleCanvas('n-2-grouped');
    var groups = [
      [0, 0, '#809bce'], [1, 0, '#809bce'], [1, 1, '#809bce'], [1, 2, '#809bce'], 
      [2, 0, '#95b8d1'], [3, 0, '#95b8d1'], [3, 1, '#95b8d1'], [3, 2, '#95b8d1'], 
      [2, 1, '#b8e0d2'], [2, 2, '#b8e0d2'], [2, 3, '#b8e0d2'], [3, 3, '#b8e0d2'], 
      [2, 4, '#d6eadf'], [3, 4, '#d6eadf'], [3, 5, '#d6eadf'], [3, 6, '#d6eadf'], 
    ];
    c4.drawSplittedTriangle(100, 0, 200, Math.pow(4, 2), groups);

    var c5 = new TriangleCanvas('n-2-grouped-removed');
    var groups = [
      [0, 0, 'rgb(90, 90, 90)'], [1, 0, '#809bce'], [1, 1, '#809bce'], [1, 2, '#809bce'], 
      [2, 0, '#95b8d1'], [3, 0, '#95b8d1'], [3, 1, '#95b8d1'], [3, 2, '#95b8d1'], 
      [2, 1, '#b8e0d2'], [2, 2, '#b8e0d2'], [2, 3, '#b8e0d2'], [3, 3, '#b8e0d2'], 
      [2, 4, '#d6eadf'], [3, 4, '#d6eadf'], [3, 5, '#d6eadf'], [3, 6, '#d6eadf'], 
    ];
    c5.drawSplittedTriangle(100, 0, 200, Math.pow(4, 2), groups);
    c5.context.strokeStyle = '#ff7777';
    c5.context.lineWidth = 3;
    c5.drawTriangle(100, 0, 100);

    var c6 = new TriangleCanvas('n-2-grouped-neighbours');
    var groups = [
      [0, 0, '#e7ecf6'], [1, 0, '#e7ecf6'], [1, 1, '#e7ecf6'], [1, 2, '#e7ecf6'], 
      [2, 0, '#95b8d1'], [3, 0, '#95b8d1'], [3, 1, '#95b8d1'], [3, 2, '#6d8699'], 
      [2, 1, '#b8e0d2'], [2, 2, '#b8e0d2'], [2, 3, '#b8e0d2'], [3, 3, '#657b73'], 
      [2, 4, '#d6eadf'], [3, 4, '#89958e'], [3, 5, '#d6eadf'], [3, 6, '#d6eadf'], 
    ];
    c6.drawSplittedTriangle(100, 0, 200, Math.pow(4, 2), groups);
    
    var trapezoids = [
      [[1, 2], [3, 2], [2.5, 3], [1.5, 3]],
      [[1, 2], [1.5, 3], [1, 4], [0, 4]],
      [[3, 2], [4, 4], [3, 4], [2.5, 3]],
    ];
    c6.drawTrapezoid(trapezoids[0], 200 / 4, '#ff7777');
    c6.drawTrapezoid(trapezoids[1], 200 / 4, '#ff7777');
    c6.drawTrapezoid(trapezoids[2], 200 / 4, '#ff7777');

    var c7 = new TriangleCanvas('final');
    var groups = [
      [0, 0, '#435062'], [1, 0, '#92afd7'], [1, 1, '#92afd7'], [1, 2, '#92afd7'], 
      [2, 0, '#95b8d1'], [3, 0, '#95b8d1'], [3, 1, '#95b8d1'], [3, 2, '#95b8d1'], 
      [2, 1, '#b8e0d2'], [2, 2, '#b8e0d2'], [2, 3, '#b8e0d2'], [3, 3, '#b8e0d2'], 
      [2, 4, '#d6eadf'], [3, 4, '#d6eadf'], [3, 5, '#d6eadf'], [3, 6, '#d6eadf'], 
    ];
    c7.drawSplittedTriangle(100, 0, 200, Math.pow(4, 2), groups);
    
    var trapezoids = [
      [[1.5, 1], [2.5, 1], [3, 2], [1, 2]],
      [[1, 2], [3, 2], [2.5, 3], [1.5, 3]],
      [[1, 2], [1.5, 3], [1, 4], [0, 4]],
      [[3, 2], [4, 4], [3, 4], [2.5, 3]],
      [[1.5, 3], [1, 4], [3, 4], [2.5, 3]],
    ];
    trapezoids.forEach(function(el) {
      c7.drawTrapezoid(el, 200 / 4, '#ff7777');
    });
  }());
</script>
