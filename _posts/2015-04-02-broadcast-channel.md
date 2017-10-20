---
layout: post
title:  "BroadcastChannel API"
date:   2015-04-02 17:13:46
permalink: broadcastchannel-api/
categories: programming
author: Mahdi
---

[BroadcastChannel API](https://developer.mozilla.org/en-US/docs/Web/API/Broadcast_Channel_API)
is a new API used to communicate between same-origin tabs opened by the same user.

Why
===
Let's say you open two GitHub tabs, the [rust repository](https://github.com/rust-lang/rust) and [your stars](https://github.com/stars) page. You decide to star the awesome rust repository, but then you have to
refresh your stars page to see your new star. That's sad. There must be a way for GitHub to refresh
your stars page in case you star something in another tab, right?

![Broadcast Channels, SATISFIED](/img/broadcast-channels.jpg)

Show me something!
==================
Okay, open another page of my blog in a new tab. Now open up your console and enter this:

{% highlight javascript %}
channel.postMessage('Anybody hears me?');
{% endhighlight %}

Boom.

I've put this code in my `<head>`, pretty simple:

{% highlight javascript %}
var channel = new BroadcastChannel('egg');

channel.addEventListener('message', message => {
  alert('Got a message from the other tab:\n' + message.data);

  // Egg
  document.querySelector('header').classList.add('channel');
});
{% endhighlight %}


How
===
BroadcastChannels are pretty easy, here I'm going over the small details.

Creating channels
-----------------
BroadcastChannels are constructed with a single argument, their name. Browsing contexts should use
this name to communicate over a specified channel. There's no limit to how many channels you can create.

In the first sentence of article I said it's used to communicate between tabs, but it's actually "browsing contexts".
[Browsing contexts](http://www.w3.org/TR/html5/browsers.html#browsing-context) are any environments owning a `Document`, e.g. tabs, windows, iframes, etc.

{% highlight javascript %}
var channel = new BroadcastChannel('star');
{% endhighlight %}

Channels have only one property, `name`.

Methods
-------
Channels have two methods:

### #postMessage(data: Anything)
This is the method used to broadcast a message to everyone subscribed to this channel. `data` can be any kind of Object.

### #close()
This method is used to leave a channel, in case you don't want to hear from the channel anymore.

Try leaving `channel` from my blog pages, and posting messages with others.

Events
------
Channels inherit from [`EventTarget`](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget), so you can use  `addEventListener`, `removeEventListener` and `dispatchEvent` methods.

Channels have only one event:

### message
The event object passed to this event is a [`MessageEvent`](https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent) with the `data` property set to the actual message sent using `postMessage`.

---

Another example
===============
Let's Fix GitHub
----------------

Okay, let's try something cool, I promise you will love it. Open a browser with [BroadcastChannel support](http://caniuse.com/#feat=broadcastchannel) and Install [GreaseMonkey](http://www.greasespot.net/).

You have to add two scripts, one for repository pages, and one for the stars page.

Click "New User Script", and fill the inputs like this:

![GreaseMonkey New User Script](/img/greasemonkey-new-user-script.png)

![GreaseMonkey New Script](/img/greasemonkey-github-stars.png)

In the Script Editor, enter this:

{% highlight javascript %}
// join the "Stars" channel
var channel = new BroadcastChannel('Stars');

// reload the page when someone from a github.com tab broadcasts a message
channel.addEventListener('message', message => {
  location.reload();
});
{% endhighlight %}

Now create another script and fill the form like this:

![GreaseMonkey New Script](/img/greasemonkey-github-repositories.png)

Use this code:

{% highlight javascript %}
// join the "Stars" channel
var channel = new BroadcastChannel('Stars');

// once the star/unstar forms are submitted, broadcast a message to
// all github.com tabs
$('.starring-container form').submit(e => {
  channel.postMessage('refresh');
});
{% endhighlight %}

Save, refresh your pages and Voila! You can now Star/Unstar any repository while your stars page
is open, and your stars page will refresh immediately.

---

That's it, I really like this API as it's best of both worlds, simple and useful.

There are a lot of things which can be done with help of BroadcastChannels, I would love to hear your feedback on this API.
