---
layout: post
title:  "Let's Begin"
date:   2015-03-09 17:13:46
permalink: beginning/
categories: self
---

So, I've decided to write about what I do and what I love.

It's possible that you find anything here, so don't be surprised, but most of it
is going to be about my programming journey, what I learn, what I do, and my opinions.

I like Medium, but I want a place in which I dictate, so here's my personal blog.


{% highlight javascript linenos %}
const SECOND = 1000;
let style = document.querySelector('style');

setInterval(() => {
  const now = Date.now(),
        birth = new Date(2015, 2, 9).getTime(),
        color = `#(now - birth).toString(16).slice(0, 6)`,

  style.textContent = `#mahdi path {
                         stroke: ${color} !important;
                       }`;
}, SECOND);
{% endhighlight %}

<style></style>

<script type="application/javascript;version=1.8">

var SECOND = 1000;
var style = document.querySelector('style');

setInterval(function() {
  var now = Date.now(),
      birth = new Date(2015, 2, 9).getTime(),
      color = '#' + (now - birth).toString(16).slice(0, 6);

  style.textContent = '#mahdi path {\
                         stroke: ' + color + ' !important; \
                      }';
}, SECOND)
</script>

