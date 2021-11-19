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
qemu-system-x86_64 -cdrom archlinux-2021.11.01-x86_64.iso -boot order=d -drive format=raw,file=disk.img -m 8G -smp cpus=4
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
- Install necessary dependencies
{% highlight bash %}
pacman -S flex base-devel xmlto kmod inetutils bc libelf git cpio perl tar xz
{% endhighlight %}
- Copy configuration of archlinux (optional: also [use modprobed-db to remove unnecessary modules](https://wiki.archlinux.org/title/Kernel/Traditional_compilation#Default_Arch_configuration))
{% highlight bash %}
zcat /proc/config.gz > .config
{% endhighlight %}
- Make!
{% highlight bash %}
make -j8
{% endhighlight %}
- Install the newly built Kernel
{% highlight bash %}
make modules_install
VERSION=5.10
cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-linux${VERSION}
mkinitcpio -k $VERSION -g /boot/initramfs-linux${VERSION}.img
{% endhighlight %}
- Run grub-mkconfig to add a menu option for this new kernel
{% highlight bash %}
grub-mkconfig -o /boot/grub/grub.cfg
{% endhighlight %}
- Reboot and choose the new kernel (might be under "Advanced" in the bootloader)
