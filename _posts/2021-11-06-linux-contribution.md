---
layout: post
title: "My first contribution to Linux Kernel: Step by step"
date: 2021-11-06 00:00:00
permalink: first-linux-contribution/
categories: programming
published: false
---

_*This post is under construction. I am in the process of trying to contribute to the Linux Kernel. This post is not finished and will get updated as I go*_

I use a MacBook Pro (mid-2014) with macOS, so I need to have a virtual machine for running a linux system with my kernel. I will also be doing the coding on this linux virtual machine as building the kernel is easier in a linux system than macOS.

# Setting up the Virtual Machine (Archlinux)
 
I create a virtual machine with Archlinux on my macOS using QEMU:

1. [Download the Archlinux iso image](https://archlinux.org/download/)
2. Create a qemu disk
{% highlight bash %}
qemu-img create disk.img 15G
{% endhighlight %}
3. Start the machine and [install Archlinux](https://wiki.archlinux.org/title/Installation_guide)
{% highlight bash %}
qemu-system-x86_64 -cdrom archlinux-2021.11.01-x86_64.iso -boot order=d -drive format=raw,file=disk.img -m 8G
{% endhighlight %}
4. Start the machine after installing (note I forward 2222 to 22 so I can SSH/SCP to the virtual machine. I also set 4 CPUs so I can use threads for faster builds in the VM)
{% highlight bash %}
qemu-system-x86_64 -boot -drive format=raw,file=disk.img -m 8G -smp cpus=4 -net user,hostfwd=tcp::2222-:22 -net nic
{% endhighlight %}
5. Install dependencies for building the kernel
{% highlight bash %}
pacman -S gcc git make
{% endhighlight %}
6. Clone linux (note that you may want to clone another repository other than the stable if you are working on a specific part. For example I had to clone the `netdev` group's tree). [List of different trees](https://git.kernel.org/).
{% highlight bash %}
git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
# netdev group
git clone git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
{% endhighlight %}
7. Install the necessary dependencies for building the kernel
{% highlight bash %}
pacman -S flex base-devel xmlto kmod inetutils bc libelf git cpio perl tar xz
{% endhighlight %}
8. Copy configuration of archlinux (optional: also [use modprobed-db to remove unnecessary modules](https://wiki.archlinux.org/title/Kernel/Traditional_compilation#Default_Arch_configuration))
{% highlight bash %}
zcat /proc/config.gz > .config
{% endhighlight %}
9. Make sure you enable debugging configurations
{% highlight bash %}
CONFIG_FRAME_POINTER=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_DEBUG_INFO=y
{% endhighlight %}
10. Make! The `-j8` parameter specifies the number of threads to be used by the build. My CPU has 8 threads and so I use it all.
{% highlight bash %}
make -j8
{% endhighlight %}
11. Install the newly built Kernel. I create this as a script file and run it after every build from the root of repository.
{% highlight bash %}
make -j8 modules_install
RELEASE=$(cat include/config/kernel.release)
cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-linux${RELEASE}
mkinitcpio -k $RELEASE -g /boot/initramfs-linux${RELEASE}.img
mkinitcpio -k $RELEASE -s autodetect -g /boot/initramfs-linux-fallback${RELEASE}.img
grub-mkconfig -o /boot/grub/grub.cfg
{% endhighlight %}
- Reboot and choose the new kernel (might be under "Advanced" in the bootloader)

# Development Environment

Setup your environment for development. Mine consists of setting up tmux so I can have multiple terminals and neovim.

In the guest machine:
{% highlight bash %}
pacman -S neovim openssh tmux
echo '[[ -z "$TMUX" ]] && exec tmux' >> /etc/profile
# also follow https://github.com/junegunn/vim-plug for Neovim
{% endhighlight %}

And in the host:
{% highlight bash %}
scp -P 2222 ~/.tmux.conf root@localhost:/root
scp -r -P 2222 ~/.config/nvim root@localhost:/root/.config/
{% endhighlight %}

One thing I found necessary, due to limited storage, is a script to cleanup each linux version after I'm done with them, since they create a couple of files in different places. I call this `cleanup-linux.sh`:

{% highlight bash %}
VERSION=$1
rm /boot/vmlinuz-linux${VERSION}
rm /boot/initramfs-linux${VERSION}.img
rm /boot/initramfs-linux-fallback${VERSION}.img
rm -r /usr/lib/modules/${VERSION}
{% endhighlight %}

# Debugging
There is a `pr_debug` function used over the code, in order to enable those logs in `dmesg` for a specific module, you can do this:

{% highlight bash %}
echo 8 > /proc/sys/kernel/printk
echo 'module ip_set +p' > /sys/kernel/debug/dynamic_debug/control
{% endhighlight %}

Note that, this works if you have dynamic debug enabled in your `.config`:
{% highlight bash %}
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
{% endhighlight %}

You can then look at `dmesg` while running the code to see those logs:
{% highlight bash %}
dmesg
{% endhighlight %}

## Kernel Oops, Bug and Panic

If you get a Kernel Oops, Kernel Bug or similar, here are some good resources on how to read and understand the output:

- [Bug Hunting](https://www.kernel.org/doc/html/v5.0/admin-guide/bug-hunting.html?highlight=dmesg)
- [Understanding a Kernel Oops!](https://www.opensourceforu.com/2011/01/understanding-a-kernel-oops/)
- [How to read, understand, analyze and debug a linux kernel panic](https://stackoverflow.com/questions/13468286/how-to-read-understand-analyze-and-debug-a-linux-kernel-panic)
- [Kernel Debugging](https://docs.freebsd.org/en/books/developers-handbook/kerneldebug/)

### Reading The Call Trace

For example, I wanted to be able to understand the call trace of this Kernel Bug: [bug-207773](https://bugzilla.kernel.org/show_bug.cgi?id=207773)

The call trace section starts with:
```
[226832.533889] Call Trace:
[226832.534377]  <IRQ>
[226832.534776]  recent_entry_update+0x52/0xa0 [xt_recent]
[226832.535690]  recent_mt+0x167/0x328 [xt_recent]
[226832.536488]  ? set_match_v4+0x96/0xb0 [xt_set]
[226832.537407]  ipt_do_table+0x24f/0x610 [ip_tables]
[226832.538277]  ? ipt_do_table+0x33e/0x610 [ip_tables]
[226832.539146]  ? l4proto_manip_pkt+0xde/0x440 [nf_nat]
[226832.540049]  ? ip_route_input_rcu+0x40/0x280
[226832.540831]  nf_hook_slow+0x40/0xb0
[226832.541477]  ip_forward+0x424/0x450
[226832.542116]  ? ip_defrag.cold+0x37/0x37
[226832.542814]  ip_rcv+0x9c/0xb0
```

The way I did it was to run `gdb` on the `vmlinux` file in the root of the repository after build, and then load the symbol files of each module that is relevant:

{% highlight gdb %}
gdb vmlinux

(gdb) add-symbol-file vmlinux.o
(gdb) add-symbol-file net/ipv4/netfilter/ip_tables.o
(gdb) list *(ipt_do_table+0x24f)
(gdb) list *(nf_hook_slow+0x40)
{% endhighlight %}

<!--However, sometimes some files in some modules might not have their object files available readily (e.g. `xt_recent.o` was missing from my tree). In this case, I had to look at the Makefile in `net/netfilter`, and found this:
{% highlight make %}
obj-$(CONFIG_NETFILTER_XT_MATCH_RECENT) += xt_recent.o
{% endhighlight %}

So I enabled this flag in `.config`:
{% highlight bash %}
CONFIG_NETFILTER_XT_MATCH_RECENT=m
{% endhighlight %}

And then built the module again (I had to export the config in this case for some reason):
{% highlight bash %}
export CONFIG_NETFILTER_XT_MATCH_RECENT=m
# rebuild the module
cd net/netfilter
make -j8 -C ../../ M=$PWD modules
{% endhighlight %}

And then, I can load this symbol file as well:

{% highlight gdb %}
(gdb) add-symbol-file net/netfilter/xt_recent.o
(gdb) list *(recent_entry_update+0x52)
(gdb) list *(recent_mt+0x167)
{% endhighlight %}-->

# Creating your patch

Here are some good guidelines on how to prepare and send your patch:
- [The perfect patch](https://www.ozlabs.org/~akpm/stuff/tpp.txt)
- [Linux kernel patch submission checklist](https://www.kernel.org/doc/html/v4.10/process/submit-checklist.html)

There might be a file called `MAINTAINERS` in the root of the repository you cloned, it may include some notes and tips on how to make the life of maintainers easier by following some guidelines, read it!

# What did I work on?

The first issue I was interested in turned out to be an invalid bug: I found that out by investigating the script the user was testing and measuring how much time each part of the script took to find out the main culprit: [bug-214851](https://bugzilla.kernel.org/show_bug.cgi?id=214851). But I learned a lot during this alone, mostly about how to build things quickly, where to look for modules, how to enable debugging for them, etc.

I wanted to work on the network modules, so I looked around there.

In order to understand how networking module of linux works, I read these resources:
- [Tracing the Way of Data in a TCP Connec- tion through the Linux Kernel](https://archive.org/details/linux_kernel_data_flow_short_paper/page/n1/mode/1up?view=theater)

