---
layout: post
title: "You can read my blog posts using `curl`"
subtitle: "Publishing raw version of my blog posts"
date: 2022-07-27 00:00:00
permalink: raw-permalinks-for-accessibility/
categories: programming
---

I realised that my blog and its content, even though very simple and
lightweight, are only accessible using a full-fledged web browser. I thought it
would be interesting if my blog posts were available to be read using an even
simpler interface, cURL!

To make this work, I made a very simple Jekyll plugin that automatically
generates a "raw" page for every post I create. These raw pages are available by
prepending `/raw` to the URL of my posts.

Try it out:

```
curl https://theread.me/raw/raw-permalinks-for-accessibility/
curl https://theread.me/raw/embodying-the-avatar-videogames/
curl https://theread.me/raw/rust-box-str-vs-string/
```

You can get a raw listing of my blog posts at `/raw/`:

```
curl https://theread.me/raw/
```

To make this easily readable on small screens and terminals, I used vim's
text-width setting to make sure my lines do not exceed 80 characters:

```
:set tw=80
```

And to reformat my posts, I went over my text lines (I avoided breaking code
sample lines), and used `gq` to reformat each section.

The source code for my blog is available on my
[git](https://git.theread.me/thereadme/theread.me) server, you can find the source
for [the raw
plugin](https://git.theread.me/thereadme/theread.me/src/branch/master/_plugins/raw.rb)
as well as the [layout
file](https://git.theread.me/thereadme/theread.me/src/branch/master/_layouts/raw.html).
