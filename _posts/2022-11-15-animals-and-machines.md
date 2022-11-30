---
layout: post
title: "On Efficiency of Animals and Machines"
subtitle: "I find comparing animals and machines absurd"
date: 2022-11-15 00:00:00
permalink: animals-and-machines/
categories: personal, science
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

Moreover, Stable Diffusion is only capable of doing one thing, a very narrow and
focused task: given text, output images. I'm not dismissing the complexity of
this task, but it is still a narrow task. Every being's world lends it with
innumerable affordances, and an animal surviving in the world has to be able to solve
a lot more problems, and yet, the animal is an order of magnitude more efficient
at using its faculties to survive. Stable Diffusion focuses on one task, and is
extremely energy-inefficient at solving that.

## Hummingbird

My favourite example when it comes to comparing animals and machines, is the
tiny hummingbird, which I think is more impressive than any machine made by
humans.

Hummingbirds can range from as small as 5 centimeters weighing 2 grams up to 23
centimeters and weighing 18 - 24 grams. They can flap their wings 12 times per
second in larger species and around 80 times per second in smaller species.
Some hummingbirds can fly up to 54 kilometers per hour in wind tunnels!

Now these tiny little birds are experts at hovering in the air, and keeping
their long beaks stable while sucking nectar from flowers, and when I say
expert, I mean it! Look at this video of a hummingbird keeping itself stable
while being blown with a 32km/h wind, and I remind you, the
bird itself weighs only a few grams, but can hold itself stable against such
wind!

<iframe class="centered" width="560" height="315" src="https://www.youtube-nocookie.com/embed/JyqY64ovjfY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

How efficient are hummingbirds? In a sense, they actually have the highest
metabolism of any warm-blooded animal, so they end up consuming their own body
weight in nectar every single day {% cite hummingbird %}, but on the other hand,
if we consider human-made machines, can we build any kind of machine with our
current understanding and technology that weighs only a few grams, can hold
itself stable in winds as fast as 32km/h, mates with its own species to produce
offsprings, and only consumes a few grams of flower nectar per day? I'm still
over-simplifying the hummingbird by naming a few actions it takes, but in
reality of course, the animal is much more complex and does a lot more than
this.

# Conclusion

I think comparing such marvels of efficiency with machines is
absurd. We don't come close to making something as efficient and intelligent as
animals with such complexity, and our _intelligent_ tools are only intelligent in a narrow manner, all the while
consuming energy that could feed an animal for _years_ to do what they do.

Our current approach of computation does not seem to lend itself
to such order-of-magnitude efficiency contrast. Moore's Law does not apply
anymore {% cite rotman2020we %} and I don't see us improving CPU efficiency in a
significant manner that brings us closer to biological efficiency of animal
cognition without a breakthrough in the underlying technology and model we use
for computation and cognition.

# References

{% bibliography --cited %}
