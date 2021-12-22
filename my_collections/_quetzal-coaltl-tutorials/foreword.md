---
layout: tutorial_post
img: schemes/decrypt_sampling_scheme.png
title: Foreword
tagline: the C++ Coalescence Template Library
description: Defining the goals of the tutorial
use_math: false
---

Welcome to the Quetzal-CoalTL tutorials!

If you are here, then there is a good chance that you are interested in writing
complicated code to simulate complicated stuff in complicated landscapes
and you would like to understand how this library is ever going to
simplify your life.

Well, the problem with stacking up complications
is that at the end it's quite tricky to give you an overview of the library
capabilities and possible extensions without having you running away in utter despair.

So I will try to keep things simple. But even doing so, there will be problems
along this bumpy road I'm trying to carve for us. So don't get discouraged if
something happens, and **contact me to help you out**: describe you problem in the comment
section, or write me an email, or open an issue on github!

# What's in it for me?

The big goal of this series of tutorial is to have you be able to use the library
to write your own Quetzal-EGG or extend the library in the direction of your choice.

But to do so you will have to understand a few concepts. Some are scientific in nature
(how to model gene genealogies in landscapes), other are pure C++ concets (*e.g.*, template programming,
policy-based design) and other are concepts specific to Quetzal-CoalTL (*e.g.*, how the library manipulates gene tree).

It means that we will have to begin with simplistic models and goals (*e.g.*, simulating a gene copy walking in a straight line, or counting the increasing number of leaves in a coalescing tree).
Not as fun as full blown Quetzal-EGGS, but assuredly more tractable.

At the end, we will tie everything together to come up with a customized, usable simulator!
