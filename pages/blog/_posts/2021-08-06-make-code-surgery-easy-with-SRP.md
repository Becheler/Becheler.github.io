---
layout: blog
title: Make code surgery easy with the Single Responsibility Principle
author: Arnaud Becheler
featured_image: code_surgery_front_desk_SRP.jpg
---


The **Single Responsibility Principle** (one of the [5 SOLID principles](2018-10-20-how-to-write-solid-code.md)) states that *each class should do just one thing, but do it well.*
Why so? Well, think about the way our body organs work together! Do we digest stuff
at the exact same place we process cognition? Of course not! We evolved **differentiated organs** that are specialized for a
**very small subset of related functions**.
For example, the main responsibility of the **eye** is to perceive **light**.
The **liver** has been blessed with the **detoxification** responsibility.
Remark how clear structure of human body organs makes surgeries surprisingly easy - or at least doable. Surgeons can remove a diseased liver
and replace it with a healthy liver in 6 hours. Can you replace that old, slow and buggy
code of yours with a healthier version in the same amount of time?

![Single Responsibility Principle: make code surgery possible]({{ site.url }}/draw/code_surgery_front_desk_SRP.jpg)

Objects in our code should ideally work in the same way organs do in a healthy body.
Big organs with clearly separated functions, all in constant interaction. They produce, exchange,
communicate, sometimes fail, but their structure is still striking and robust.

Of course, it happens often that to perform one task very well one has to do a lot
behind the curtain: take for example the **amygdala**. To do *decision-making* right,
it needs to process both *memories and emotional responses* so it can associate adverse
experiences with negative feelings - and trigger the right decision next time you
encounter a tiger (that is ~~running of course~~ getting closer to properly document
their stripe pattern - you're a biologist after all!).

*Complexity is structured complications*.

![Single Responsibility Principle: make code surgery easy]({{ site.url }}/draw/scalpel.jpg)

If you want to see programmatic organs emerge from
the primordial soup of your code, try to follow these steps:

1. **Think bigger! Think smaller! Think at the right level!**

   Identify the responsibility of the piece of code you're working with: what is it supposed to do **conceptually**.

   For example: *I want my class to read a tiger strip from a picture and match it to the tigger ID*.

   Don't think about *lists*, *pointers* or *arrays*. These are often **implementation details** that should
   be hidden behind a neat class interface. Find the right level of abstraction you're working with by naming
   a **tiger strip** a `tiger_strip` in your code, not a `boost::matrix::<double>`!
2. **Code surgery is easier when you operate on clearly delimited programmatic organs.**

   Establish a clear separation between what is the responsibility of one class and another.

   Sometimes things are more easily said than done. When you look into the details, maybe you will
   discover that *matching a strip to a number* actually involves some pretty badass
   pattern recognition stuff that should become the responsibility of
   another class.
3. **A big bad code is better than no code at all**.

   Begin somewhere.

   Even if you feel bad, or even if you don't know *yet* what your class is supposed to do.
   As long as you are intentional with the **S.R.P.**, it's fine. Even if you feel bad
   writing that awful blob of code at least you know when, where
   and why you violated the *S.R.P*, what consequences it could have and what would be the solutions.

   But as you progress, don't hesitate to export responsibilities when your class becomes too big:
   a class that does too many things at the same time is impossible to test or debug.
4. **Find the balance between the mammoth and the atom**.

   You will overuse the **S.R.P** it. Don't. But you will. That's how you learn!

   When you will have exported aaaaall
   responsibilities of this big mammoth class to hundreds of smaller and smaller other classes, you will be left
   with a scrawny class which only responsibility is to represent ... a boolean.
   That's useless, one class already does that perfectly: the boolean class.
   But at least you will be able to recognize the early stages of misusing the **Single Responsibility Principle**!
