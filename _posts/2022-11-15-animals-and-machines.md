---
layout: post
title: "Animals and Machines: A Misled Comparison"
subtitle: "I find comparing animals and machines absurd"
date: 2022-11-13 00:00:00
permalink: animals-and-machines/
categories: personal, science
published: false
math: true
author: Mahdi
---

I find comparing animals and machines absurd, because of course, animals win!
What am I talking about here, what am I comparing? I've had multiple occasions
where I have had to defend the stance that animals, and in general, biological
beings are much more efficient and intelligent than human-made
machines and AI. Let's first set the stage.

## Intelligence

What do I mean when I talk about intelligence? I think the definition I find on
Wikipedia is a fair one:

> Intelligence has been defined in many ways: the capacity for abstraction,
logic, understanding, self-awareness, learning, emotional knowledge, reasoning,
planning, creativity, critical thinking, and problem-solving. More generally, it
can be described as the ability to perceive or infer information, and to retain
it as knowledge to be applied towards adaptive behaviors within an environment
or context. {% cite enwiki:1120152608 %}

## Efficiency

This I define as the ratio of useful output from a system to the amount of
energy it needs to do carry the action.

# An Absurd Comparison

"This AI is much more intelligent than dogs", or even in more extreme cases "This
AI is better than humans!".

Some AI achievements are _impressive_, for sure. Stable Diffusion or Dall-E
achieve impressive results. GPT-3 can be impressive sometimes, self-driving cars
are also sometimes impressive, but being impressive is not the same as being
intelligent or efficient, let's dissect what goes on behind such impressive
feats of AI, and then we can look at the factors in the open.

## Stable Diffusion

What does it take for Stable Diffusion to create an image given some text?

The dataset used to train Stable Diffusion is the
[LAION-5B](https://laion.ai/blog/laion-5b/) dataset with 5.85 billion image-text
pairs. {% cite techcrunch-stability-ai %}

This means, we first had to have 5.85 billion images made by humans, and then
labelled by humans, that's a ton of energy and time spent on the training data
of this model.

To train the model, 100 Nvidia A100 GPUs were used, for a total of 150,000
GPU-hours, at a cost of $600,000. {% cite techcrunch-stability-ai %}

Let that number sink in, 150,000 GPU-hours were required to train this model
with 5.85 billion images. Nvidia A100 GPU has a max thermal design power (TDP) of 300W, and
while TDP is not the best measure of actual power consumption, it can serve as a
ballpark. So this GPU uses 300W of power per GPU hour, which is 45000kW for
150,000 GPU hours, this is discounting the energy consumption of all the other
components of the computers training stable diffusion.

## Human

Now imagine I asked a human artist to draw the same image I asked of Stable
Diffusion. I'm pretty sure this human has not seen 5.85 billion images with text
prompts, and I'm also pretty sure they have not had to spend $600,000 for
training (including surviving and feeding themselves), and they also did not
have to use as much energy as 150,000 GPU-hours of Nvidia A100s. A human body
consumes food to generate energy, and the basic amount of energy consumption of
the human body is about 4kJ/kilogram of body weight and daily hour {% cite
khan2012energy %}. To get watts per hour, we can use the formulas below:

Power in watts $P_W$ is equal to the energy in joules $E_j$, divided by the time period in
seconds $t_s$:

$P_W = E_j / t_s$

So given that I weigh 70kg, my body consumes around 280kJ per hour, plugging
into the formula:

$P_W = 280000 / 3600$

$P_W = 77.7$

So my body consumes somewhere around 77.7 watts per hour, that's only 680652 watts or
680kW per year! With this consumption, I could live 66 years before I would
consume the same amount of energy as the training procedure of Stable Diffusion.

I hope we can agree that as impressive as Stable Diffusion is, it does not beat
a good human artist, and it sure is not as efficient as a human. I think to say that any
AI is smarter than humans in any subject, must take into account the efficiency
of the system as well.

## Hummingbird

My favourite example when it comes to comparing animals and machines, is the
tiny hummingbird, which I think is more impressive than any machine made by
humans, let me explain!

{% bibliography --cited %}
