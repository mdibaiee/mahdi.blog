---
layout: post
title:  "ES7 Array and Generator comprehensions"
date:   2015-06-06 13:47:00
permalink: es7-array-generator-comprehensions
categories: es7, generator, array
---

Array comprehension is a new feature proposed for ES7, with a new syntax
to create new arrays from existing [iterables](http://www.2ality.com/2015/02/es6-iteration.html),
comprehensions can replace `map`, `filter`.

Generator comprehension brings the same feature to generators, this is a more
significant change as it removes the need to write new generators for simple map / filter operations.

Comprehensions are currently only supported by Firefox, use Firefox 30+ or [Babel](https://babeljs.io/repl/) to run the examples. The Node.js version using generator `function* ()`s is available at the [repository](https://github.com/mdibaiee/array-vs-generator) (doesn't require transpilation, use latest node).

#Syntax

The syntax is pretty simple, you can use only `for of` and `if` inside comprehensions.

Array comprehensions:
{% highlight javascript %}
let numbers = [1,2,3,4,5];

let even = [ for (n of numbers) if (n % 2 === 0) n ];
// equivalent:
// let even = numbers.map(n => { if (n % 2 === 0) return n });

console.log(...even); // 2 4
{% endhighlight %}

Generator comprehensions:
{% highlight javascript %}
// yield 0...5
let generator = function* () {
  for (let i = 0; i < 6; i++) {
    yield i;
  }
}

let squared = ( for (n of generator()) n * n );
// equivalent (not lazy):
// let squared = Array.from(generator()).map(n => n * n);

console.log(...squared); // 0 1 4 9 16 25
{% endhighlight %}

You can also nest comprehensions:

{% highlight javascript %}
// yield 0...5
let generator = function* () {
  for (let i = 0; i < 6; i++) {
    yield i;
  }
}

// yield three numbers after number
let after = function* (number) {
  for (let i = 1; i < 4; i++) {
    yield number + i;
  }
}

// for each number of 0...5, yield an array of 3 numbers after it
let nested = ( for (n of generator())
               [ for (i of after(n)) i ]
             )

console.table(Array.from(nested));
// 1, 2, 3
// 2, 3, 4
// 3, 4, 5
// 4, 5, 6
// 5, 6, 7
// 6, 7, 8
{% endhighlight %}

#Lazy
This is one of the most important advantages of generators over arrays and things alike.
The reason why I'm including this here is to give you a good reason to write generators instead of arrays
 while generator comprehensions make it extremely easy to write them — this is a proof of their usefulness.

In programming, laziness means doing nothing until the results are requested or in simpler terms, avoiding unnecessary work.
For example, when you create an array and map it, the result will be evaluated no matter you need it now or not, you need the whole thing or a part of it, etc.

Take this example:

{% highlight javascript %}
let bigArray = new Array(100000);
for (let i = 0; i < 100000; i++) {
  bigArray[i] = i;
}

let first = bigArray.map(n => n * n)[0];
console.log(first);
{% endhighlight %}

You know what happens here, first, map is evaluated, returning thousands of squared numbers, then
the first element is returned. We must allocate and evaluate the whole squared array to be able to know about it's first or second element.

Think of optimizing it, is it possible to get the desired result without storing
temporary arrays in memory? Can we get the first number directly without consuming a big chunk of memory?

Yes, using generators, Look at this:

{% highlight javascript %}
let bigArray = function* () {
  for (let i = 0; i < 100000; i++) {
    yield i;
  }
}

let squared = ( for (n of bigArray()) n * n );

console.log(squared.next());
{% endhighlight %}

Let's see what happens in this case.
Here, we create a generator which will yield numbers 0...100000, nothing is actually allocated or evaluated, we just have a generator which will return a new number every time we call `next()`.
Then we use generator comprehension to create another generator which squares the numbers our `bigArray()` generator yields, again, we don't evaluate or allocate anything, we just create a generator which will call another generator's `next()` method, square the results, and yield it.

Now when we call `squared.next()`, the `squared` generator calls `bigArray().next()`, squares the results and yields it, it doesn't do any unnecessary work, it's lazy.

If you profile heap/memory usage and running time, you will see the difference.

I have prepared a Node.js version of the test case. With the help of [`process.memoryUsage()`](https://nodejs.org/api/process.html#process_process_memoryusage) and [`console.time`](https://developer.mozilla.org/en-US/docs/Web/API/Console/time) we can easily see the difference.
It's about ten times faster with two times less space used, isn't that awesome?

[Repository: mdibaiee/array-vs-generator](https://github.com/mdibaiee/array-vs-generator)

![Array vs Generator performance](/img/array-vs-generator.png)

If you want to know more about lazy iterators, I recommend raganwald's [Lazy Iterables in JavaScript](http://raganwald.com/2015/02/17/lazy-iteratables-in-javascript.html).

More:
[MDN: Array Comprehensions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Array_comprehensions)

[MDN: Generator Comprehensions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Generator_comprehensions)

[MDN: for...of](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/for...of)

[MDN: Iterators and Generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators?redirectlocale=en-US&redirectslug=JavaScript%2FGuide%2FIterators_and_Generators)

[ES6 in Depth: Generators](https://hacks.mozilla.org/2015/05/es6-in-depth-generators/?utm_source=javascriptweekly&utm_medium=email)
