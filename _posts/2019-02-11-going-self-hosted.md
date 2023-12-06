---
layout: post
title:  "Going Self-Hosted: Moving away from Google and others"
date:   2019-02-11
permalink: self-hosted/
categories: life
excerpt_separator: <!--more-->
---

Since 3 years ago, I have always been eager to move away from Google and other
privacy-invading companies. I have had my successes and failures in doing so,
here I'm going to put out my stack of tools for moving away from Google and
going self-hosted.

<!--more-->

I first tried to move away from Google 3 years ago, and at the time, I did not
have enough resources to self-host much. I started by creating my own email
server, but I couldn't afford a cloud storage. I also did not know about the
alternatives available to Google Calendar, Google Keep, and other tools I was
using at the time, so it was pretty hard keeping up that way.

After a year and a half, after my phone was stolen, I decided I will stick with
Google apps with the coming of my new phone. I kept using Google services for
less than a year, but I was frustrated. I had given up my privacy and control
over my data for convenience, but that's not what I wanted. So I decided I'm
going to switch away again, and I will self-host the tools necessary.

A lot has changed since the first time I switched away, I will sketch below the
tools that I have replaced and how.

# microG

If you want to avoid using Google Services on your Android phone, there is
[microG](https://microg.org/) for that. I flashed my phone with an
[AEX](http://aospextended.com/) ROM which supports microG, so it was not
particularly hard to set-up on my phone, but I've heard it can be hard to set it
up since it's doing some trickery to replace Google's services on your phone.

This also means you have to flash a custom ROM and root your device in order to
do this, so maybe this option is not for everyone, but I think with Google
Services active in your phone, you can't really be sure what's going on behind
the curtains.

# Email

One of the most common means of communication for us in the digital world, we
exchange a lot of information through email, including personal and work-related
information. As such, I deem email an important piece of privacy-sensitive
information.

My solution for email is a self-hosted Postfix + Dovecot + SpamAssassin on my
server. It is not the most straightforward thing to set up, by [this
DigitalOcean
tutorial](https://www.digitalocean.com/community/tutorials/how-to-configure-a-mail-server-using-postfix-dovecot-mysql-and-spamassassin)
makes it all the easier.

I have also heard of [Mail-in-a-Box](https://mailinabox.email/) which is
supposed to make setting up your own mail server a breeze! I didn't know about
this at the time I set up my server, but it could be a better choice, so perhaps
give it a try and let me know.

# Cloud Storage

A cloud storage is necessary for syncng your data among your devices and keeping
your information safe from physical loss. I chose
[Nextcloud](https://nextcloud.com/) and I couldn't be more satisfied. It has
clients for every major operating system, and I use it to back up my files,
synchronize my calendar and contacts between my Linux and my Android devices.

The installation and activation is fairly straightforward, and again, I followed
a [DigitalOcean
tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-nextcloud-on-ubuntu-16-04)
to set up the service and have been using it since.

I also bought a DigitalOcean Space for $5/month, with a capacity of 250G, which
is a fairly good price and worth its value. See [this
discussion](https://www.digitalocean.com/community/questions/is-it-possible-to-mount-do-spaces-as-external-storage-in-nextcloud-as-i-mount-aws-s3-storage)
about attaching a DigitalOcean space to Nextcloud.

# Contacts and Calendar

I learned about [DAVx](https://f-droid.org/packages/at.bitfire.davdroid/) and
[ICSx](https://f-droid.org/en/packages/at.bitfire.icsdroid/), which are tools
for syncing your contacts and calendar, with support for Google Calendar as
well. This means that I can still have access to my workplace calendar which is
on Google, and have my own personal calendars synchronized using Nextcloud.

These tools integrate with whatever Calendar and Contacts application you are
using on your phone, so you are free to choose whatever calendar and contacts
application you like.

# Notes

For note-taking, I use a simple Markdown/todo.txt editor called
[Markor](https://f-droid.org/en/packages/net.gsantner.markor/) while Nextcloud
handles the synchronization so I have access to my notes both on my computer and
my phone. I use [vimwiki](https://github.com/vimwiki/vimwiki) to organize and
edit my notes on my computer. Nextcloud also provides extra applications for
editing Markdown files on the web interface, which is great if you like doing
everything in your browser.

# Application Store

For downloading applications, I default to searching through
[F-Droid](https://f-droid.org/en/), and in case I don't find the tool I'm
looking for (which I mostly do!), or I'm looking for a properietary application,
such as Slack, I use [Aurora
Store](https://f-droid.org/en/packages/com.dragons.aurora/) or [Yalp
Store](https://f-droid.org/en/packages/com.github.yeriomin.yalpstore/), which
lets you search through all Google Play applications and install applications
without a fuss.

Of course, you can install the official Google Play store as well if you would
like to, but I personally am cautious about using any of Google's applications.

# Two-factor Authentication

I use [andOTP](https://github.com/andOTP/andOTP/) instead of Google
Authenticator. One feature I love about andOTP is the ability to take an
encrypted backup of your OTP keys, so you do not have to re-set all your
two-factor authentications across all services if you ever want to switch your
phone.

# Password Manager

I switched from LastPass, with its ugly, broken and distorted user experience to
[BitWarden](https://bitwarden.com/), and I couldn't ask for more! The user
experience is far superior compared to LastPass, the extension doesn't kill my
browser's performance and the Android application is great, too!

# Firefox Containers

Lastly, it's natural that we can't completely avoid using Google's tools, we can
just try to limit Google's access to our data and avoid being tracked as much as
possible. For this purpose, I started using Firefox Containers, and God, this is
a killer feature!

So now, I have a few containers set up:

- Personal: This one includes my personal accounts on websites other than Google
  that I want to stay logged-in on.
- Work: I'm logged into services that I use for work here, and it includes
  Google as well, but only for work.
- Google: This one, I use for accessing a personal Google Account I keep for
  YouTube and other services, but I'm not a serious user.
- [Temporary
  Containers](https://addons.mozilla.org/en-US/firefox/addon/temporary-containers/):
  Any websites that I have not explicitly chosen to be opened in one of the
  above containers, opens up in a new, temporary container, which means it
  doesn't have access to any cookies or information from the other containers. I
  may sometimes choose to open Google or other services in Temporary Containers
  as well if I don't see the necessity to be logged in.

This means Google will not be able to track me using my account when I'm logged
in to other services since they live in a different container, even though other
methods such as [device
fingerprinting](https://clearcode.cc/blog/device-fingerprinting/) are still
possible. With Firefox's Tracking Protection and
[uBlock](https://addons.mozilla.org/en-US/firefox/addon/ublock/) always turned
on, I am less concerned about tracking.

# Not the easiet thing

I have to admit, it's not the easiest thing to move your digital life away from
the giants, their products are built for maximum convenience, so you can't
expect to have that maximum convenience if you stop using those products, and I
think it's a far-fetched ideal to expect the same level of convenience using
free applications and tools, but I personally think it's worth it.

