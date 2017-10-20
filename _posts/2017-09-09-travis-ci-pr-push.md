---
layout: post
title:  "Difference between Travis CI tests: PR and Push"
permalink: travis-ci-pr-push/
categories: programming
excerpt_separator: <!--more-->
author: Mahdi
---

I just want to leave this here as I often tend to look it up myself and the first time it was not as easy to figure out.

When using Travis CI along with GitHub (or other git integrations), Travis runs two tests: <code>pr</code> and <code>push</code>.

![travis-pr-push-github](/img/travis-ci-pr-push-github.jpg)

Most of the time you see both tests passing and you do not have to even wonder how they are different, but it has
happened to me that one of the tests fails while the other passes and I started to wonder why.

### pr
The <code>pr</code> test is a test run on the result of a merge between the pull-request branch and the main branch.
As an example, let's say your pull-request's branch is called <code>fix-user-auth</code> and your main branch is <code>master</code>, 
in this case, <code>pr</code> merges <code>fix-user-auth</code> into <code>master</code> and then runs the tests on the result of the merge.

### push
On the other hand, <code>push</code> is run on the pull-request branch itself, without merging. So in our example above, Travis would checkout to <code>fix-user-auth</code> and run the tests.

### A case of difference

A case in which this difference might be more apparent is when your pull-request is based on a branch other than <code>master</code>, and some changes that your pull-request depends on are missing from <code>master</code>, in this case the <code>push</code> test may pass, but the <code>pr</code> test will fail.

