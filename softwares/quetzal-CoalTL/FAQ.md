---
layout: software
title: FAQ
tagline: the C++ Coalescence Template Library FAQ
description: Frequently Asked Questions
img: logos/quetzal-coaltl-fa.svg
---

-------------------
## Why this name?

Quetzalcoatl, the Feathered Serpent, was a powerful divinity from Mesoamerica who created the world
*(it still took him 600 years to reach a satisfying version, and we strongly identify to this part
  of the tale).*

The god's name is a combination of two Nahuatl words:
- **quetzal** refers to the [Resplendant Quetzal](https://en.wikipedia.org/wiki/Resplendent_quetzal) (an emerald bird symbol of freedom)
- **coatl** basically means *snake* (remember, all that glitters is not gold...) and
conveniently fits to **Coa**lescence **T**emplate **L**ibrary.

But the full name is quite difficult to pronounce, so feel free to focus on the glitter when you use **Quetzal**.

---------------------

## Who maintains the library?

**Maintainer:** [Arnaud Becheler](https://becheler.github.io/)

------------------------

## How to cite?  

**Founder article:** [Access on Wiley](https://onlinelibrary.wiley.com/doi/full/10.1111/1755-0998.12992)

**Citation:** Becheler, A, Coron, C, Dupas, S. The Quetzal Coalescence template library: A C++ programmers resource for integrating distributional, demographic and coalescent models. Mol Ecol Resour. 2019; 19: 788– 793. https://doi.org/10.1111/1755-0998.12992

----------------------

## How to contribute?  

**Clone:** ``git clone https://github.com/Becheler/quetzal.git``

**Community:** IRC channel \#quetzal on [Freenode](https://webchat.freenode.net/)

**Contribute:** Check [our Github repository](https://github.com/Becheler/quetzal) and use the [Pull Request system](https://help.github.com/articles/creating-a-pull-request/)

-------------------------

## Why a library and not a program ?

Simply because programs are **not always** the right level of configurability.

Programs are super handy, because they act as **nice black-boxes eating data** and
digesting them in a process that can be **adjusted** through a neat user **interface** (configuration files,
Graphical User Interface...). Thanks to black-box programs, biologists do not need to
worry about programming languages, design or architecture.

*But what if the options of a program do not meet our need ?*

In that case, one would have to open the box and modify the code of the program, to *extend it* towards one's need,
and in that case programming language, design and architecture **of course matter** to ease this (quite painful) experience.

Quetzal existence stems from the fact it was impossible to customize the behavior
of a pre-existing program in the desired way using the available options: we had
to re-implement **everything**.

**In short, programs are not the right level of granularity when it comes to reusing the work of other coders.**

> The key to fast development, correctness, efficiency, and maintainability is
to use a suitable level of abstraction supported by good libraries.
> -Stroustrup

--------------------------

## Wait, are you saying that programs are useless?

Nooooo...  Programs are still very usefull and user-friendly, so we are currently using Quetzal
to develop various programs!

The principal activity of a researcher is to explore new questions. Using simulations
to explore new complex models is a powerful technique, but it requires a solid
code base that can adapt to theoretical changes.

If the software breaks at each minor change, the exploration would be
painful, almost impossible!

Quetzal allows the researcher to **widen the limits** of the traditional spatially explicit
and coalescence-based simulators by allowing the customization of key aspects of
the problem: populations reaction to landscape heterogeneity and genes genealogies
simulations details.

As nothing is never free is this wild world, this flexibility comes at a cost:
using Quetzal requires technical knowledge in C++, so perhaps you would need a
Research Software Engineer to code your model.

Or you can use available [Quetzal-EGGS](/pages/quetzal_eggs/home)!

-------------------------

## What is a Research Software Engineer?

[You do not know if you are or not a RSE?](https://rse.ac.uk/who/)

-------------------------

## I'm not sure if I should use Quetzal?

**Do you have to implement or extend a coalescence-based simulator specified by a researcher?**

Well, here are some bad news:
 - Reusing or adapting existing code bases for structured coalescence is hardly feasible.
 - We never have time to re-code everything from scratch.
 - Supposing you succeed to write the correct program
in a reasonable amount of time (which is not yet certain) **sooner or later the model will change**,
and you will have to start all over again.

> Walking on water and developing software from a specification are easy if both are frozen.
> -Edward Berard

We all know that there is no such thing as frozen [specification](https://en.wikipedia.org/wiki/Software_requirements_specification). Building a
system in a changing environment is challenging, and you need the right tools.

But here are the **good news**:

As an open-source set of C++ abstractions (template classes, functions, algorithms, concepts)
Quetzal provides a nice starter-pack to write your own simulation program.

You will probably not find everything that you need.

But you will surely spare time by **not re-inventing the wheel**.

-----------------------

## I don't understand why the library components are so abstract?

**Small components libraries allow to tailor the code to your needs**.

When a scientific question leads to change a minor detail in the simulation model,
we never want to have to recode everything. So it means that this very level of
detail should be the right unit of code. In this way it is possible to only replace
a piece of code by another in a very easy way.

This is the meaning of components libraries.

And as we never want to pay computation time for flexibility, the C++ template
mechanism is used in Quetzal to build these components. In this way they can be
reused, adapted and extended to other contexts with maximal efficiency.

This is the meaning of a C++ template library: flexible, efficient, extensible.

It's easier than you think: we designed Quetzal so the code can be very expressive and compact.

--------------------

## I have another question?

Sure! Feel free to add a comment, I'll add your question to the list!
