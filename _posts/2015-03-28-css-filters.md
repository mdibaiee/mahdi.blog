---
layout: post
title:  "CSS Filters are awesome!"
date:   2015-03-28 17:13:46
permalink: css-filters/
categories: css
---

I've been working on the [CSS Filter Editor widget](https://bugzilla.mozilla.org/show_bug.cgi?id=1055181) in Firefox Developer Tools for a couple of weeks, <s>it should land soon</s> It's here!. Thanks to [Patrick Brosset](https://medium.com/@patrickbrosset) for mentoring me and [Tim Nguyen](https://github.com/nt1m) for his great contributions.

Here is an [online version](http://mdibaiee.github.io/CSS-Filter-Tooltip/) to use as a playground. This version is modified to be cross-browser and therefore is a little different from the original widget used in Firefox. <s>It doesn't seem to work in Chrome.</s>

You can also use [David Walsh's demo](http://davidwalsh.name/demo/css-filters.php), although it doesn't have as much flexibility.

CSS Filters are supported by most modern browsers ([Can I Use CSS Filters](http://caniuse.com/#feat=css-filters)), if your browser doesn't support this, please change your browser (I recommend [Firefox](https://www.mozilla.org/en-US/firefox/new/)).

I don't like long-bla-bla-articles, so let's get to it.

Introduction
============

CSS Filters introduce a few useful effects and some image adjusting functions, namely blur, drop-shadow, contrast, brightness, [and a few others](https://developer.mozilla.org/en-US/docs/Web/CSS/filter) which can be really useful if used properly.

A simple demo showing blur, contrast and brightness combined (hover over image):

<iframe width="100%" height="300" src="//jsfiddle.net/mdibaiee/zLmyhe7t/embedded/result,css" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

I group filters by the type of value they take, let's explain them briefly:

Length
------
  These filters accept a length value (px, em, cm, [etc](http://www.w3.org/Style/Examples/007/units)). blur is the only member of this family.

Percentage
----------
  These filters accept percentage values, but if you omit the percentage sign, the value is multiplied by 100, e.g. `contrast(2)` is another way of writing `contrast(200%)`. Negative values have the same effect as zero.

  Most filters explain themselves, I'm not going to repeat \`Adjusts ${x} level\` like a parrot.

  * brightness
  * contrast
  * grayscale
  * invert
  * opacity
  * saturate
  * sepia

### invert

  I first understood how cool this filter can be after I saw Tim Nguyen using this in theme switching. Yeah you can't invert everything and "Yay, I have a new theme", but you can use invert on some elements and it works flawlessly, believe me.

<iframe width="100%" height="100" src="//jsfiddle.net/mdibaiee/373dnby8/embedded/result,css" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

### opacity
  You might wonder why do we have this function, as we already have an opacity property in CSS, that's because the opacity property is not hardware accelerated, but the filter property is hardware accelerated in most browsers, which includes this function.

Angle
-----
  hue-rotate is the only function to accept an angle value (degree / radian).

###hue-rotate
  If you're familiar with [Hue](https://en.wikipedia.org/wiki/Hue) you probably know that it's measured by angles. The hue-rotate rotates the hue circle of an image relative to it's current hue value (360 and 0 have the same results).

<iframe width="100%" height="300" src="//jsfiddle.net/mdibaiee/smk922fh/embedded/result,css" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

Special
-------
  These filter's don't fit in any of the groups above, they have special/mixed values.

### drop-shadow
  The drop-shadow filter accepts a *shadow-list*, four length values, and one color. box-shadow and text-shadow also accept shadow lists.

  You're probably familiar with shadow lists already: `drop-shadow(x y radius spread color)`. Unfortunaly spread doesn't work in either Chrome or Firefox as of this writing — It is treated as an error.

  drop-shadow is pretty cool, as it doensn't have the limitations of box-shadow and text-shadow. box-shadow applies a shadow to the outer shape, but drop-shadow applies a shadow to elements independant to their shape, they might be triangles, PNG's with transparent background or just anything.

  drop-shadow clones the element's image, moves it to the offset defined, applies blur and changes it's color, putting it under the original element. Couldn't do it better:

  ![drop-shadow explained](/img/dropshadow.gif)

  Here is an example, a PNG image with transparent background and a CSS triangle made using the border hack:

<iframe width="100%" height="150" src="//jsfiddle.net/mdibaiee/z077vbs0/embedded/result,css" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

### url
  With the url function we have the power of CSS and SVG Filters in one place. You can reference an SVG element by linking to it with a hash of the filter element's ID:

{% highlight css %}
filter: url(/example.svg#filter)
{% endhighlight %}

  If you want to know more about SVG Filters, I recommend [MDN's tutorial on SVG Filters](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Filter_effects).

### Custom
  Now those filters are pretty cool, but what if I told you this is [going to be] done with CSS?

  ![Map Folding with Custom CSS Filters](/img/map.jpg)

{% include caption.html text='Source: http://www.adobe.com/devnet/archive/html5/articles/css-shaders.html' %}

  Custom Filters allows usage of vertex and fragment shaders which run directly in the GPU. Custom filters' specs is subject to change, so there's no implementation yet. For more info on this topic follow the links below:

  * [Getting started with CSS custom filters](http://alteredqualia.com/css-shaders/article/#shaders)
  * [Introducing CSS shaders: Cinematic effects for the web](http://www.adobe.com/devnet/archive/html5/articles/css-shaders.html)
  * [CSS shaders specifications](http://dev.w3.org/fxtf/custom/)

Gotchas
=======

You now have a basic understanding of filters, good. Here are a few gotchas you'd better know.

Order matters
-------------
The order in which filters are applied matters. Take this example:

{% highlight css %}
filter: blur(10px) contrast(2);
{% endhighlight %}

Hey, browser, please blur the element, then double the contrast of the blurred element. (blurred parts have their contrast affected)

{% highlight css %}
filter: contrast(2) blur(10px);
{% endhighlight %}

Hey browser, please double the contrast of my element, then blur it out. (high contrast image is blurred normally)

Here is the actual comparison:

<iframe width="100%" height="300" src="//jsfiddle.net/mdibaiee/51nLy3vs/embedded/result,css" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

Inheritance
-----------

Okay, you now know the order of filters matters, the filter property is not actually *inherited*, but when you apply a filter on a parent element, of course it's children are affected too, but what if the children have their own css filters? Ah-ha! CSS properties are applied bottom-up, which means childrens' filters are applied first.

<iframe width="100%" height="300" src="//jsfiddle.net/mdibaiee/o40d7cs7/embedded/result,css" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

Implementation
--------------

I said using the url function we have "the power of CSS and SVG filters in one place", but the CSS filters are actually implemented using SVG filters! You know, the functions are actually referencing to an svg generated in the browser. Here is the list of [CSS Filter equivalents](http://www.w3.org/TR/filter-effects/#ShorthandEquivalents).

Go Wild
=======

You can use CSS Filter on *any* element, experiment different things; `<video>`, `<canvas>`, `<iframe>`, GIF images, etc.

My try (although I couldn't get the GIF and CSS animation to be in sync, know a solution? Leave a comment please):

<iframe width="100%" height="300" src="//jsfiddle.net/mdibaiee/hjaL0ka3/4/embedded/result,css,js" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

-----

That's it, you can subscribe to my [RSS]({{ "/feed.xml" | prepend: site.baseurl | prepend: site.url }}) or follow me on [Twitter](https://twitter.com/{{ site.twitter_username }}) to get more articles like this.

<style>
  #mahdi {
    transition: filter 1s ease;
    -webkit-transition: filter 1s ease;
  }
  #mahdi:hover {
    filter: blur(3px);
    -webkit-filter: blur(3px);
  }
</style>
