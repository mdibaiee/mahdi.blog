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
- Start the machine after installing (note I forward 2222 to 22 so I can SSH/SCP to the virtual machine. I also set 4 CPUs so I can use threads for faster builds in the VM)
{% highlight bash %}
qemu-system-x86_64 -boot -drive format=raw,file=disk.img -m 8G -smp cpus=4 -net user,hostfwd=tcp::2222-:22 -net nic
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
- Make! The `-j8` parameter specifies the number of threads to be used by the build. My CPU has 8 threads and so I use it all.
{% highlight bash %}
make -j8
{% endhighlight %}
- Install the newly built Kernel. I create this as a script file and run it after every build from the root of repository.
{% highlight bash %}
make -j8 modules_install
RELEASE=$(cat include/config/kernel.release)
cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-linux${RELEASE}
mkinitcpio -k $RELEASE -g /boot/initramfs-linux${RELEASE}.img
mkinitcpio -k $RELEASE -s autodetect -g /boot/initramfs-linux-fallback${RELEASE}.img
{% endhighlight %}
- Run grub-mkconfig to add a menu option for this new kernel
{% highlight bash %}
grub-mkconfig -o /boot/grub/grub.cfg
{% endhighlight %}
- Reboot and choose the new kernel (might be under "Advanced" in the bootloader)
- Setup your environment for development. Mine consists of setting up tmux so I can have multiple terminals and neovim.
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

# Debugging Logs
There is a `pr_debug` function used over the code, in order to enable those logs in `dmesg` for a specific module, you can do this:

{% highlight bash %}
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
