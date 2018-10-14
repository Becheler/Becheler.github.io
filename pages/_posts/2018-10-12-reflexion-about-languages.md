---
layout: blog
title: Thoughts about natural languages and their abstractions
---

{{ page.date | date: "%d %B %Y" }}

# Thoughts about programming languages.

## Why programming has to be so frustrating?

Programming concepts can seem so arid when you come from the biological world!

Technical aspects of programming languages are useless if you do not understand *why* the
technique has been invented.

The most complex features of modern languages (like for example [move semantics](https://stackoverflow.com/questions/3106110/what-are-move-semantics) in C++)
obviously do not exist just for the pleasure to complicate our learning curve and
make us suffer (or do they?).

These features exist because they allow us to clearly express in our code core ideas that
would have been very tricky to express otherwise.

So technique enables us to be **clear** and **precise**. Clear enough to be understood
by the **human**, precise enough to be understood by the **machine**.

This duality is at the heart of the programming activity.

![machine versus human languages]({{site.url}}/pictures/machine_vs_human_languages.jpg)

## A more human perspective to programming

Reaching *concision* is a challenging goal!

Sometimes we are tempted to be lazy and to talk only to the machine, obfuscating
the code to the human intelligence!

Design solutions are here to bring the **computational problem formulation**
to the reach of our **human intelligence**.

As I was struggling with design concept not so long ago, a software developer introduced me to
the idea that I should think about programming languages as actual languages, and
about the programming activity as a creative, linguistic, almost literary experience.

In short: to think about **code as a vector of communication between coders**.

It made so much sense that it radically changed the way I was grasping code.
For the better of course: enhanced readibility, modularity, efficiency resulted
from the paradigm switch.

So let me present you coding as a literary, linguistic experience!

![Derek over exagerating a bit]( {{site.url}}/draw/pure_poetry.png)


## Reframing the programming activity

To understand better why software design and all the related technical jargon
are so important, a pleasant first step is to reframe the question in a *more intuitive perspective*:

> *Which common points do programming languages share with natural languages like English, French, Japanese?*

Quick answer: **They all mirror our human incapacity to handle too much information.**

Natural languages are crowded with loosely defined terms that allow us to efficiently express general ideas.

Perhaps that the main purpose of this blog is to get familiar with the idea that
programming languages are **not so different**
from natural languages in the sense that we can not pretend to remember all
the details of our codes, so we **need** to build abstract words we can use
to better communicate ideas to our pairs.

We will see in other posts which tools programming languages give us to do so.

By expressing more **human** concepts in our code, we allow a concise description
of our problems and solutions. Because it requires creativity and skills, it becomes
actually a very pleasant job!

> "Computer programming is an art, because it applies accumulated knowledge to the world, because it requires skill and ingenuity, and especially because it produces objects of beauty. A programmer who subconsciously views himself as an artist will enjoy what he does and will do it better." - Donald Knuth

## Your job? Creating new words!

When you call a function, for example using R:

`my_sample <- rnorm(sample_size, mean, square_deviation)`,

you have to understand that your life has been here facilitated by *someone* who wrote hundreds
(or thousands) of code lines so you can manipulate comfortably the rather abstract
concept of *normal random distribution sampling*.

As biologists caring about computational solutions, we will also need, at some point,
to write thousands of code lines *just* to be able to **express in our codes abstract
biological concepts in a clear and efficient way**.

So we have to forget about computer-oriented words like *matrix*, *vectors*, *lists*, *dictionaries*
 ... and begin to invent in our codes new words like *genotypes*, *individuals*, *landscapes*!

This process is called a **higher level of abstraction**, and programming is all about that!

According to the language you are using, you will have different tools
to **invent this new semantic field you need** to describe your biological problem.

## Programming activity as a linguistic experience!

As biologists, we learned how to manipulate very abstract words like *ecosystems*,
*environmental niche* or *natural selection*, but not how **to reflect** this degree
of generality in our codes.

It can actually be detrimental for the research activity (as after some months no one
remembers what these 5000 strange code lines describe, the code is lost), and I think it is worth
to take a moment to wonder why, and to think about solutions.

It is widely admitted in the software engineering world that we tend to pay way too much attention
to **code details**, when we should actually make our best to **forget them**: in
this sense we should actually try to mimic the way natural languages work.

The urge to follow this principle of forgetting details is not new, and has been termed
[information hiding](https://en.wikipedia.org/wiki/Information_hiding).

It's a core programming concept, but not very
well understood by our research communities, so we will share *a lot* about that!

## Benefits

Thinking about programming languages as I think about natural languages encouraged
me to write more literal, more abstract, more human-friendly code.

This metaphor encouraged a **paradigm shift** switching my mindset about the programming activity from a rather **frustrating observation**:

> "I am writing arid instructions for this stupid machine."

to a **more fulfilling one**:

> "I am explaining to my fellow researcher-coder, perhaps even myself in a near future,
perhaps someone else in 20 years, the problem at hand and how to solve it.
I want the code to be as clear a understandable as the text of a
scientific paper".

So I used this as a constant reminder of our human condition to
inevitably forget details dispersed through the code, were they documented.

Operating this mental shift, I was actually acknowledging my own weakness: oblivion! so I could *adapt using the tools offered by the programming language that exist for this very purpose*.

Doing so, my code became more *structured*, *reusable*, *modular*, *maintainable*.

All the **qualities** we would like to enforce in our science projects!

##  Final thoughts

Going through this post helped you understanding better how much **abstraction is important for us**, poor humans (machine actually don't care).

The mindset presented here, along with time, patience and the required technical knowledge, can help you to write **better code**.

I hope that you will ultimately come to the idea that **programming is not only about a technical description to the machine** of a computational solution described in terms of 0 and 1.

Perhaps that programming can also be a **new linguistic experience** where a human has to write a text that can be understood **both** by the dumbest machine that can crunch
the numbers **and** by a human intelligence able to understand the purpose.

I hope you will finally see programming languages as wonderful, living, powerful instruments of communication, that open *new ways to think about the real world we aim to describe as biologists!*

So have fun reading these posts, have fun coding, and appreciate the true beauty and intelligence of the programming activity!
