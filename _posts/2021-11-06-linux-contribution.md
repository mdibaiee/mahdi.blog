---
layout: post
title: "My first contribution to Linux Kernel: Step by step"
date: 2021-11-06 00:00:00
permalink: first-linux-contribution/
categories: programming
author: Mahdi
published: false
---

November 6th:
Create a virtual machine for Archlinux on my macOS using QEMU:
- [Download the Archlinux iso image](https://archlinux.org/download/)
- Create a qemu disk:
{% highlight bash %}
qemu-img create disk.img 15G
{% endhighlight %}
- Start the machine and [install Archlinux](https://wiki.archlinux.org/title/Installation_guide)
{% highlight bash %}
qemu-system-x86_64 -cdrom archlinux-2021.11.01-x86_64.iso -boot order=d -drive format=raw,file=disk.img -m 8G
{% endhighlight %}
- Start the machine after installing
{% highlight bash %}
qemu-system-x86_64 -drive format=raw,file=disk.img -m 2G
{% endhighlight %}
- Install dependencies:
{% highlight bash %}
pacman -S gcc git make
{% endhighlight %}
- Clone linux:
{% highlight bash %}
git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
{% endhighlight %}

