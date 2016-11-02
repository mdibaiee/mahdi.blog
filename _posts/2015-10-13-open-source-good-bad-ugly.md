---
layout: post
title:  "Open-source: The Good, The Bad and The Ugly"
date:   2015-10-13 06:15:00
permalink: open-source-good-bad-ugly/
categories: experience, open-source, opinion
---

I have been doing Open-source for a while, I don't call myself an "expert" or something like that,
but I'd like to share my opinion and experience on contributing to, and maintaining open-source code.

So, I've been following and contributing to open-source projects for quite a time,
and I have had different experiences every time. There are always good and bad experiences
along a road, it's never a heaven, never a hell. I've had contributions as small as fixing a typo in README, and as big
as adding a new feature to Firefox Developer Tools or refactoring a whole repository!

Here I'm going to share my experiences and what I've learned along the way that you should consider
if you want to take this road.

The Good
--------
I love open-source, it's awesome how people share their efforts with others, and others give feedback to
the maintainer to make the software better. It's an always-growing system, even if a maintainer stops maintaining,
it's possible to _fork_ a repository and continue it, although not as easy, but possible.

The best part of doing open-source, in my opinion, is building connections and learning from others.

Whether you are maintaining or contributing to a project, you are going to learn new things, it just happens.

If you are a maintainer of a repository with a countable amount of users, you are going to constantly learn your mistakes from others,
finding these mistakes by yourself is really hard, because you can't easily look at a subject _the other way_,
but users have this potential to look at your code with their eyes, seeing mistakes you can't see.

If you are contributing, following or just exploring projects, you are definitely going to learn, the solutions people suggest to a problem,
the way they communicate, etc.
Usually, not always, the maintainer has a better knowledge over the subject of project than you, so you are going to learn from him and other contributors
by reading their code or exploring the issues and how they've been solved. I personally learned a lot this way. I would volunteer to fix a bug, then the maintainer and other contributors would show up to give their suggestions and ideas on the issue, which I would then learn from. I also subscribe to interesting issues that I don't know how to fix to see how they get solved.

The Bad
-------
First off, the most annoying thing about open-source contributions is that people (I'm looking at you, maintainers) think
that contributors are jobless bored people who don't know how to spend their time and have come to waste some time on some random open-source project, NO, seriously.

I have a job, I totally care about my time and I'm not making a Pull-request because I'm bored.

Now, why is that important to know: it has happened to me a couple of times that I ask on an issue:

_"- Okay, I'm interested, what **exactly** has to be done?"_

_"- Great, please do x, y, z"_

_... some time later_

_"- Here is x, y and z, please review and merge"

_"- Oh, thank you very much, but you know, now that I think of it, I don't want x, y or even z. Closing."

and I'm like:

<!-- ![Are you kidding me?](/img/are-you-kidding-me.jpg) -->
<img alt='Are you kidding me?' src='/img/are-you-kidding-me.jpg' />

{% include caption.html text='Are you kidding me?' %}

This is the worst thing that can happen to you, try to avoid it, you don't want your valuable time wasted.

How to avoid it you ask, there is a sign that I've found which leads to this problem most of the time and that's **lack of clear specification**, just like with clients, if the maintainer doesn't specify what should be done, you should stop.

It happened to me, just like the past discussion, except he didn't tell me _"Please do x, y, z"_, he made himself look
too busy and said: _"The title says it all"_, no, it doesn't say it all. "x, y and z" can be implemented in `2^9` ways, and sadly,
you are not going to accept the `192`th way, as you "don't like it". Do not get trapped in these time-wasting situations, I wish maintainers understood how valuable people's times are.

The Ugly
--------
The sad part about open-source is, if the maintainer decides not to support the project anymore,
people will _kind of_ suffer. If the maintainer abandons the project, the project is *almost* doomed, as forking and continuing is really hard, reading the code from bottom up and understanding it isn't easy, and as there is no outcome, people usually decide to abandon a project once they lose interest in the topic.

If I personally lose interest in a project I've made, I'll abandon it, I will try to guide new users through but I usually
don't offer as much support, I have more important things to do, it's really sad, but true.

To prevent this from happening, you must be able to make money out of your project, or your project must be really interesting
and challenging to keep you working on it.

------

That's it, please note that everything you read here is my opinion, it's not a rule, not a judgment, it's my opinion and experience. If you would like to discuss this further, put a comment below or reach me at [twitter](https://twitter.com/mdibaiee).
