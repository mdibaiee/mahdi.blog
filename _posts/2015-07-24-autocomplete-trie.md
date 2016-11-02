---
layout: post
title:  "Autocomplete using Tries"
date:   2015-07-24 09:44:00
permalink: autocomplete-predict-trie
categories: algorithms
---

In this article, I'm going over creating an autocompletion/prediction system using a data-structure called Trie, it's fast and easy to customize.

Trie
====

[Trie](https://en.wikipedia.org/wiki/Trie) is a simple data-structure most commonly used as a dictionary, it looks like so:

![Trie](/img/trie.jpg)

As you see, it's just a *tree*, a set of nodes connected to other [child] nodes, but the nodes have a special relationship:

Each child node extends it's parent with one extra character.

{% highlight javascript %}
// Something like this
child.value = parent.value + 'c';
{% endhighlight %}

It's pretty easy to traverse this tree and predict the next possible words.

Implementation
--------------

We're going to use ES6 classes to create our `Trie` and `Node` classes.

Let's start with our simple Node class:
{% highlight javascript %}
class Node {
  constructor(value = '') {
    this.value = value;
    this.children = [];
  }
}
{% endhighlight %}

Unlike [binary trees](https://en.wikipedia.org/wiki/Binary_tree) where each node has a left and right child, Trie nodes don't necessarily have a limit on how many children they can have.

Trie class:
{% highlight javascript %}
class Trie {
  constructor() {
    this.root = new Node();
  }

  add(value, parent = this.root) {
    for (let i = 0, len = value.length; i < len; i++) {
      let node = parent.children.find(child => child.value[i] === value[i]);

      if (!node) {
        node = new Node(value.slice(0, i + 1));
        parent.children.push(node);
      }

      parent = node;
    }

    return parent;
  }

  find(value, parent = this.root) {
    for (let i = 0, len = value.length; i < len; i++) {
      parent = parent.children.find(child => child.value[i] === value[i]);

      if (!parent) return null;
    }
    return parent;
  }
}
{% endhighlight %}
Every Trie must have a root node with empty value, that's how our single-character nodes follow the rule of Tries.

Ok, our first method, `add` handles adding a value to the trie, creating necessary parent nodes for our value.
At each iteration, we compare the `i`th character of our value, with `i`th character of current node's children's value,
if we find one, we continue to search the next branch, else, we create a node with `value.slice(0, i + 1)` and move onto the created node.

It might be a little hard to grasp at first, so I created a visualization of this method to help you understand it easier, take a look:
[Trie Visualization](/autocomplete-trie/demo/add.html)

Then we have our find method, which searches for the given value in the trie. The algorithm for searching is the same, comparing by index and moving to the next branch.

Example
========
That's it for our simple Trie class, now let's create an actual input with autocomplete functionality using our Trie.

{% highlight html %}
<input>

<div class='results'>

</div>
{% endhighlight %}

I put some random names and stuff into three categories, results: [data.json](/autocomplete-trie/demo/data.json)

Now we have to create a Trie of our data:
{% highlight javascript %}
const trie = new Trie();

let data = {...}; // read from data.json

for (let category in data) {
  for (let item of data[category]) {
    let node = trie.add(item);
    node.category = category;
  }
}
{% endhighlight %}
As simple as that, our trie is made, it looks like this: [Data](/autocomplete-trie/demo/data.html)

Now, let's actually show results:
{% highlight javascript %}
const input = document.querySelector('input');
const results = document.querySelector('#results');

input.addEventListener('keyup', () => {
  results.innerHTML = '';

  const nodes = trie.find(input.value);

  if (!nodes) return;

  for (let node of nodes.children) {
    const category = node.category ? `- ${node.category}` : '';

    results.innerHTML += `<li>${node.value} ${category}</li>`;
  }
});
{% endhighlight %}
[Autocomplete 1](/autocomplete-trie/1.html)
![Autocomplete 1](/img/autocomplete-1.png)
This will only show the instant-childs of the word entered, but that's not what we want, we want to show *complete* words, how do we do that?

First, we need a way to detect complete words, we can have a flag to recognize complete words, we can modify our `add` method to
automatically flag whole words or we can manually add the flag after adding the node, as we did by setting a category for our words,
so we already have a flag to recognize whole words, that's our `category` property, now let's add a new method to our Trie class to find
whole words.

{% highlight javascript %}
...
  findWords(value, parent = this.root) {
    let top = this.find(value, parent);
    if (!top) return [];

    let words = [];

    top.children.forEach(function getWords(node) {
      if (node.category) words.push(node);
      node.children.forEach(getWords);
    });

    return words;
  }
...
{% endhighlight %}

And change our event listener like so:
{% highlight javascript %}
const input = document.querySelector('input');
const results = document.querySelector('#results');

input.addEventListener('keyup', () => {
  results.innerHTML = '';

  const nodes = trie.findWords(input.value); // << Change

  if (!nodes.length) return; // << Change

  for (let node of nodes) { // << Change
    const category = node.category ? `- ${node.category}` : '';

    results.innerHTML += `<li>${node.name} ${category}</li>`;
  }
});
{% endhighlight %}
[Autocomplete 2](/autocomplete-trie/2.html)
![Autocomplete 2](/img/autocomplete-2.png)
Ta-daa!

We have our autocomplete working! Let's add zsh-like-tab-to-next-char functionality.

{% highlight javascript %}
input.addEventListener('keydown', e => {
  // Tab Key
  if (e.keyCode === 9) {
    e.preventDefault();
    const current = trie.find(input.value);

    if (!current.children.length) return;

    input.value = current.children[0].name;
  }
});
{% endhighlight %}

That's it! We have an input with autocomplete and tab-to-next-char. Isn't it awesome?

[Final Result](/autocomplete-trie/2.html)

*Pst! I have a repository of algorithm implementations in ES6, you might want to take a look! [mdibaiee/harmony-algorithms](https://github.com/mdibaiee/harmony-algorithms)*
