---
layout: post
title:  "Mathematical Induction for proving tiling methods"
date:   2017-10-19
permalink: mathematical-induction-proving-tiling-methods/
categories: math
math: true
---

On my way towards self-taught data science, I've stumbled upon the need to be
proficient with mathematical proofs, so I picked up the amazing [How To Prove
It: A Structured
Approach](https://www.amazon.com/How-Prove-It-Structured-Approach/dp/0521675995)
by Daniel J. Velleman; and I've been fascinated by mathematical proofs since
then.

One of the uses for [Mathematical
Induction](https://en.wikipedia.org/wiki/Mathematical_induction) which I've
found to be pretty cool is proving methods for tiling shapes.

Here is an example:

Suppose $n$ is a positive integer. An equilateral triangle is cut into $4^n$
congruent equilateral triangles, and one corner is removed. Show that the
remaining area can be covered by trapezoidal tiles like this: <img
src='/img/tiling/trapezoidal.jpg' class='inline' width='30'/>

<canvas id='tiling-triangle' width='200' height='200' class='centered'></canvas>
{% include caption.html text='An example of n = 2. The dark tile is removed.' %}

Just to be clear, by _cover_ we mean covering without any overlaps, so you can't
have two overlapping trapezoidal tiles.

As with any mathematical induction solution, we start with the base case, which
is $n = 1$, in that case the triangle looks like this:

<canvas id='base-case' width='100' height='100' class='centered'></canvas>

In this case, it's obvious that we can cover the leftover area using trapezoidal
tiles consisting of three equilateral triangles (the second row), so:

----

Base case: $n = 1$ then the triangle has $4^1 = 4$ tiles, and by removing the
top-most tile, the second row can be covered using a single trapezoidal tile. 

----

Now for the induction step, we have to somehow show that after adding 1 to $n$,
that is, by multiplying the tiles by $4$, we can still cover the triangle by
trapezoidal tiles. To show this, we start by assuming we have a triangle with
$4^n$ tiles, which we know can be covered by trapezoidal tiles, then we add the
new tiles and show that they, too, can be covered by trapezoidal tiles.

----

Induction Step: Suppose we have a triangle split into $4^n$ tiles, and we know
by induction hypothesis that it can be covered by trapezoidal tiles.

Now suppose we have another triangle with $4^{n+1}$ tiles, that means, $4$ times
as many triangles as our original triangle. We can then group the new bigger
triangle into 4 congruent triangles, one of which we know can be split into
trapezoidal tiles by removing one of it's tiles.

For the three left triangles, we can find a neighbouring corner and assume the
tile on that corner to be removed, and then cover the rest by trapezoidal tiles.
Afterwards, since we had three such corners, and they are neighbouring corners,
we can cover these three corners with one trapezoidal tile, thus completing the
triangle.

----

Now that's a mouthful, in simpler terms, we are following these steps (for $n = 2$):

<canvas id='n-2' width='200' height='200' class='centered'></canvas>

First, we split the whole triangle into 4 smaller groups:

<canvas id='n-2-grouped' width='200' height='200' class='centered'></canvas>

Then, we know that one of the triangles can be covered by trapezoidal tiles if
we remove one of it's tiles, that's the induction hypothesis (the case for $4^n$
which is proved in the base case):

<canvas id='n-2-grouped-removed' width='200' height='200' class='centered'></canvas>

Leaving the top triangle behind, we now find neighbouring corners among the
three left triangles, and we assume the tiles in those corners to be removed
(they are not actually removed as we are constrained to remove only one tile):

<canvas id='n-2-grouped-neighbours' width='200' height='200' class='centered'></canvas>

Now we can cover the rest of these triangles by a single trapezoidal tile,
similar to the case of $n = 1$.

Afterwards, we see that the three neighbouring tiles form a trapezoidal tile,
therefore we can now put the last piece there to complete the tiles.

<canvas id='final' width='200' height='200' class='centered'></canvas>

This procedure can be applied recursively on larger values of $n$ as well, so
this concludes a proof of tiling an equilateral triangle divided into $4^n$
equilateral triangles using trapezoidal tiles after removing a single piece.

<script src="/js/tiling-shapes.js"></script>
