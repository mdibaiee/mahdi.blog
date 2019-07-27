---
layout: post
title:  "Iran Sanctions: A Story of Discrimination and Isolation"
date:   2015-03-28 17:13:46
permalink: css-filters/
categories: programming
author: Mahdi
---

Let me take you through a story, a story on what it feels like to be isolated from the world, not by choice, but rather by force. This is a story of discrimination, of monopoly, of rolling eyes and of utterances that affect lives of milions.

Living in Iran, or any sanctioned country for that matter, you learn to read "anyone, anywhere" as "but not you". You soon learn "worldwide shipping" excludes you, that's when you start wondering, are you not living in the "world"? Where is this "world" they talk about?

Here is an example of a beautiful, hopeful messaging from Khan Academy:

![Khan Academy's Landing Page: We’re a nonprofit with the mission to provide a free, world-class education for anyone, anywhere.](/img/discrimination/khan-academy.png)
{% include caption.html text='We’re a nonprofit with the mission to provide a free, world-class education for anyone, anywhere.' %}

No one probably realizes that this is not true, but yeah, Khan Academy is not available to Iranians, that's because [they run on Google Cloud](https://cloud.google.com/customers/khan-academy/), an infrastructure provider that completely blocks all sanctioned countries from accessing any application hosted on it. Who else hosts their service there? Take a look at the [342 item list](https://cloud.google.com/customers/) of notable customers of Google Cloud, but remember there's more.

But the story doesn't end here, of course. Let's go through the effects of sanctions on everyday lives of people, who have nothing to do with the politics of the country they are living in, and who are being discriminated only because they were born in geographical coordinates that lie in a certain boundary defined by people they don't even know.

# Internet

The internet, the tool of the global society for communicating across the planet (I do not want to use the term "world", lest it excludes sanctioned countries), _the_ tool for sharing knowledge and alike.

As if Iran's government blocking and censoring the internet wasn't enough, we now have to deal with external sanctions blocking our access as well, here's a gallery of blocked access messages we see on a daily basis:

![img/discrimination/403-forbidden-iran-sanctions.jpg]

These websites include GitHub, Slack, Kaggle, Docker, GitLab, Amazon AWS, Twitter, Bluemix, Khan Academy and more. Here is a longer, developer-oriented list (but definitely not exhaustive) list of hosts blocking our access: [freedomofdevelopers/domains](https://raw.githubusercontent.com/freedomofdevelopers/fod/master/domains).

The websites that blocked our access, mostly did without prior notice, they just disabled our accounts, took our data from us, and did not let us even take backups or exports of our data afterwards, that means lost messages, lost files and credentials.

This is, in part, caused by the global monopoly of American companies such as Google, GitHub and alike, which means if United States decides to pressure a specific target, they are likely to be left with not much of an alternative or option, since a great proportion of the land is covered by American companies.

This is a clear discrimination based on nationality. These websites do not block us because we acted in a wrong way, or even, at cases, because we live in Iran, but because we were "born" in Iran. Now you may say this is because of the law and they have no choice, alright, makes sense, we'll talk about it [later](#Of-Rolling-Eyes-and-Shrugs) in the post.

# Drugs, Medicine, and Medical Devices

There are various sources and articles on how the U.S. sanctions have affected Iranian patients by limiting exports of drugs, medical devices or by indirectly disrupting the pharmaceutical industry by cutting exports of raw material used by these companies to produce medical material. Although I am aware of, and can consciously feel the shortage in the market myself, I will refer to an article on NCBI as a proof.

Quoting from [NCBI: Addressing the impact of economic sanctions on Iranian drug shortages in the joint comprehensive plan of action: promoting access to medicines and health diplomacy](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4897941/):

<blockquote>
Although the revised and current Iranian sanctions regime does not specifically prohibit the export of humanitarian goods and pharmaceuticals, many of the administrative and regulatory processes have made it difficult to export life-saving medicines to Iran. This includes the need to navigate a complex export control regulatory process, the inability of Iranian banks to do business with the international banking system and U.S. corporations, currency shortages, and the inability to secure terms of shipping, insurance and other services needed to facilitate medicines trade [4]. As a result, millions of Iranians that suffer from life-threatening diseases have experienced “exorbitant prices”, stock outs of medicines, and are often forced to purchase drugs from the black market

[...]

Severe medication shortages in Iran are diverse and span several therapeutic classes and disease states. This includes drug shortages for other critical areas of healthcare delivery, including organ transplant drugs, and even vaccine shortages
</blockquote>

And on the topic of weakening of the pharmaceutical companies:

<blockquote>
Inaccessibility of vital medications and their raw ingredients combined with Iran’s weakening domestic pharmaceutical industry has also resulted in an influx of counterfeit, fraudulent, and substandard medicines into Iran’s health care system. An unregulated black market has developed as a byproduct of drug shortages, introducing medications whose origins and authenticity are often unknown, and has led to expired medications’ distribution and sale, even at potentially very high prices [8]. Hence, the global counterfeit medicines trade, recognized as a serious public health concern, is one that is currently being enabled as a consequence of drug shortages and ongoing Iranian economic sanctions 
</blockquote>

These bring tears to my eyes. I refer you to [the article](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4897941/) for more information.

# Rial Fluctuations: An Unpredictable Life

I'm pretty sure most of the people reading this blog post, unless they are Iranians, will not find this section familiar. It's (fortunately) not a common experience across the planet, but let me tell you about living a life of zero predictability.

Imagine this: You sell your car today, July 27th of 2019, and you start a hunt for a new car to buy as a replacement, for the sake of the example, you are looking for a second-hand car.
I don't want to bore you with millions and billions of currency being spent, as is the case in Iran, so I will use a dummy currency unit here. You sold  your car for 1000 units, and during the week you are looking for a new car, you start to see the car you just sold, is gaining price like crazy, after a week, the same car that you sold is priced at 1800 units of currency and it's growing. It's like putting a car on neutral in a downward slope and seeing it go up the hill! Now you are left with 1000 units of currency, and you are only able to buy the same car if you put in your extra 800 savings, otherwise you are going to ride a car with significantly less quality.

I am pretty sure no matter how much I try to help you visualize this, you can not comprehend what it means to live in such a situation. I always use the metaphor of being a circus actor trying to balance on a moving cylinder to describe what it means to survive the fluctuations of our currency, which in turn affects all your expenses, but not your income.

![Circus actor balancing on cylinders](/img/discrimination/act04-1.jpg)

This is also an effect of the sanctions on the economy that we people feel with our every inch and are pressured by.

# A Weak Economy's Rippling Effect

You have probably heard of Maslow's Hierarchy of Needs. This is what it looks like:

![Maslow's Hierarchy of Needs. A pyramid, from top to bottom: Self-Actualization, Esteem, Love/Belonging, Safety, Physiological](/img/discrimination/maslow.jpg)

At the bottom, there are physiological needs, like health, food, water, sleep, shelter and sex. Only once these needs are fulfilled properly, do you get motivated to even think about the next level. That means, if your physiological needs are not properly safisfied, you will not even think about safety, love and belonging, esteem or self-actualization.

Now, what all these physiological needs have in common is that they are fulfilled when there is a stable economic backbone in the country you live in. Once the economic backbone is broken, you start to lose ease of access to these physiological needs. Slowly but surely, you lose your motivation for seeking self-actualization, for esteem, for love and belonging and for safety and you hunt for your physiological needs. Once this happens for a whole population in a country, you are left with people with only one goal in their lives: to survive, and may I have to make it clear, "by any means".

With no motivation for building strong friendships and relationships, no motivation for security and safety, for feeling of accomplishment and for creative acts, the population transitions towards becoming one unsafe, cold, threatening, untrustable environment with no sense of joy or creativity.

I'm driving from my friend's house back to mine, it's roughly 10am and streets are a little crowded. I'm going through streets of Azadi District, when I see two children of ages roughly 15, punch each other in the face and kick each others stomachs over a large trash container at the side of the street. They are fighting, as if for their lives, with a ferocity you can hardly imagine to find in a 15 year old. These children do not look anything like your children, their hands are black from their fingertips to their elbows from collecting trash all day long; their clothes are not new, they do not change their clothes or take showers daily, and their backs are arched for hauling a large bag of trash for a whole day over their shoulder and back. This is what happens when you put pressure on the economy of a country. This is what the media is not telling you about the effects of sanctions. This is what needs to stop about these sanctions. This is what needs action from every person knowledgable to do something to stop it. Abuse, rape and misuse of children and adults alike is a significant, visible effect of sanctions that's often overlooked.

![A teenager collecting trash in Iran](/img/discrimination/trash-collecting.jpg)

# Of Rolling Eyes and Shrugs

Often when similar stories of this kind are shared, I expect to see comments of people shrugging to the issue with responses like "They have to comply because it's the law" or "That's how you respond to a country that wants to build nuclear weapons" or similar. They just roll their eyes at the text and shrug it off like this is how it's supposed to be.

Now, of course, it's the law and the companies have to comply; Of course, it's not a good thing that Iran wants to build nuclear weapons. What these responses get wrong is that there is no involvement by us, the people, in this. Solely because I live my daily life in a geographical location that resides in the boundaries of a place on Earth known as "Iran" doesn't mean I agree with the politics of this country, or that I want there to be nuclear weapons.

What these replies get wrong is that in democratic countries, laws can change based on what people demand. Instead of shrugging these humanitarian issues off, I suggest, please hear us out, and help echo our voice. You may not realize, but we, the people of Iran, do not have a say in what politics our government follows, or what it does, or how it interacts with other countries, but you do. The only thing we can do, is to let you know. You probably also don't realize that writing this piece itself is not a completely safe act in Iran.

What we feel when we see these responses is: They are terrorists so let them be, but we are not.

# The Common Enemy

It seems like the Iranian people are now the common enemy of all sides of the global conflict. The ever-increasing pressure we feel is not from a single source, but rather, from all sides. We have internet censorship from the inside and restricted access from the outside. We have economic pressure from the inside, with a direct influence from the outsie as well, and the same applies to every part of this conflict.
