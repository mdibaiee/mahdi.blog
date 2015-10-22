---
layout: post
title:  "My Experience Developing an Application for Firefox OS"
date:   2015-09-08 02:06:00
permalink: firefox-os-development-experience
categories: experience, firefox-os
published: false
---

So, I made my first actual product, Hawk. It all started by installing Firefox OS on my Nexus 4 just to try it out.

I searched Marketplace for essential apps I would install on Android, well,
a File Manager is necessary, I found [this](https://github.com/elfoxero/file-manager) which is good but it lacks a lot.

I was wondering if I could write a File Manager–creating was not my only intention.
I thought I would use React Redux stack and learn it on the way.

So I did, I wrote a File Manager which I personally think looks good and has good functionality (I have a lot of ideas to be applied).
I learned React Redux, too, in my opinion it's a good pattern but I think some parts of it can be improved further.

Anyways, I'm here to talk about my experience writing a Firefox OS Application.

*TL;DR: You feel right at home, debugging tools are great (WebIDE), but a little buggy sometimes.
You can use latest web features without worrying about cross-platform and these shits. The overall OS performance is lower than expected.*

#Home, Sweet Home
Writing mobile applications using Web technologies without having to worry about *porting* things,
banging your head against old webkit's weird behaviors and compatibility issues with old devices (looking at you, PhoneGap) feels great.

One thing I really like about Firefox and Firefox OS is most new and spicy JavaScript features are supported and you don't have to prefix anything.
Although I think performance of CSS animations/transitions can be improved on Firefox (they're faster on Chrome I think), you won't have much problem
writing applications for Firefox OS, I used a lot of transitions and animations in my application.

#Tools
