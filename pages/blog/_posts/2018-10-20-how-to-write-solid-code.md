---
layout: blog
title: 5 coding principles to write SOLID code
author: Arnaud Becheler
featured_image: solid.jpg
---

One promise of [Computational Biology](http://www.cbd.cmu.edu/about-us/what-is-computational-biology/)
is to develop reliable software of interest for a wide range of biological problems.
But often in biology, each new problem is a bit different than the previous one,
existing code has to evolve for various possible reasons: to adapt to **this new biological material**,
to integrate **this new super-fast algorithm**, or to scale performances with **this huuuuge dataset**.
It is safe to say that in science, like in industry, requirements do and will change *at some point*.
But as soon as they do, the code has to adapt or it becomes outdated.
And S.O.L.I.D. can help you!

![lost in translation]({{ site.url }}/draw/solid.jpg)

### They are the set of common sense guidelines we need

Because updating code is (very) costly, changes in code requirements can cause the death of
code bases that do not allow an easy integration of new and required extensions.

> Rigid and outdated scientific code is dead code.
> Well-designed outdated code has at least a chance to survive by being updated.

Writing robust code has been widely discussed by software engineers in industry
within the last decades. They have honed in on the principles of writing robust code: **S.O.L.I.D.** As scientists who write code, *we need to be aware of these solutions.*

S.O.L.I.D is an acronym for
**five core principles in object-oriented programming**, largely considered as
one of the most important acronyms in object-oriented design.

They have been initially identified by Robert Martin in the late
1990s as pivotal to design sound code using classes. Together, they
allow developers to identify problems more clearly and to reason and communicate their
**intuition regarding clean or bad code**.

When an application demonstrates [symptoms of bad design]({{site.url}}/pages/under_construction.html)
(the code is hard to modify, hard to test, hard to fix, breaks everywhere all the time... yeah we've all been there), we generally
have **an intuition of the root of the problem**:
 * *Oh man, this class too big, I cannot understand how it works!*
 * *This code base is a total mess of interdependent modules, it's impossible to debug!*
 * *Why the hell should I modify your source code to add my new feature? I don't have time to understand your code!*

Yet we often **don't know how to act**, as we don't know how **formalize** these intuitions
into a set of core rules that should be respected to make the code more robust.
**SOLID does exactly that for us.**

When my code is hard to work with, it generally turns out that I violated several of these
principles. Oopsie. But if I refactore the code to respect these principles,
I generally feel much better about the code. I can understand it, isolate it, test it, update it.

##  The Five Principles

### [**S - Single Responsibility Principle, or S.R.P.**]({{site.url}}/pages/under_construction.html)

**Each class should do just one thing, but do it well.**

Why so? Well, think about the way our body organs work together! Do we digest stuff at the exact same place we process cognition? Of course
not! We evolved differentiated organs that are specialized for a
**very small subset of related functions**.

For example, the main responsibility of the **eye** is to perceive **light**.
The **liver** has been blessed with the **detoxification** responsibility.

Of course, it happens often that to perform one task very well one has to do a lot
 behind the curtain: take for example the **amygdala**. To do *decision-making* right,
it needs to process both *memories and emotional responses* so it can associate adverse
experiences with negative feelings - and trigger the right decision next time you
encounter a tiger (that is ~~running of course~~ getting closer to properly document
their stripe pattern - you're a biologist after all!).

Remark how clear structure makes surgeries surprisingly easy - or at least doable. Surgeons can remove a diseased liver
and replace it with a healthy liver in 6 hours. Can you replace this slow and buggy
piece of code written years ago with a more functional version in the same amount of time?

Objects in our code should ideally work in the same way organs do in a healthy body.
Big organs with clearly separated functions, all in constant interaction. They produce, exchange,
communicate, sometimes fail, but their structure is still striking and robust.
*Complexity is structured complications*. If you want to see programmatic organs emerge from
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

* [**O - Open/Closed Principle**]({{site.url}}/pages/under_construction.html):
  The code should be open to extensions, but closed to modifications
* [**L - Liskov Substitution Principle**]({{site.url}}/pages/under_construction.html):
  If B is a sub-type of A, then it should be possible to replace any instance of A
  by an instance of B without ruining everything.
* [**I - Interface Segregation Principle**]({{site.url}}/pages/under_construction.html):
  No code should depend on methods that it does not use.
* [**D - Dependency Inversion Principle**]({{site.url}}/pages/under_construction.html)
  We should depend on abstractions, not implementations.

  These principles can seem a bit abstract at first
  and I don't think it worthwhile to spend days in trying to fully understand them *theoretically*
  (I personally still struggle to understand the implications of the Dependency Inversion Principle).

  But we should be aware of the core ideas SOLID expresses, so when faced with issues in our code we can analyze
  and react:

  > "Oh, this mess is just me ignoring the Single Responsibility Principle again!
    Let's refactor the code to break down complexity and be able to commit a bug fix!"


##  Does it work?

There is no formal proof that these principles actually work, but
accumulated experience within the developers community (including my own) shows that,
**better design and less problems result from writing code that respect S.O.L.I.D.** principles.

Consequently, these are absolute rules to follow at any cost, but are
rather meant as good advice and practical heuristics:

> They are common-sense solutions to common problems. They are
common-sense disciplines that can help you stay out of trouble.
[Martin, 2009](https://sites.google.com/site/unclebobconsultingllc/getting-a-solid-start)

When an entire scientific community has achieved consensus on a solution, as researchers we can perhaps give them some credence.

## The Don't-Get-Into-Trouble-Todo-List

If you want to stay out of trouble and keep control of your code, I would advise to:

* First, **learn the SOLID principles**. Try to build at least an intuition
  of the problem/solution they describe. We are half programmers, and SOLID is a
  **basics** of programming.
* Next, learn to identify **the moments when you are in difficulty** and **the reasons why**:
  does your code suffer from bad-design symptoms? Is it *rigid*? *fragile*?
* Try to link your problems and your gut feelings to a SOLID principle.
* Plan the refactoring to fix your problem: for example if the D.I.P is not respected, divide
  this big ugly mammoth class into several smaller independent ones.
* Ask for help: the online communities can be super helpful as you refactor code at minimal cost. And, exchanges on these platforms can build your programming confidence and help you make informed decisions!
* Trust yourself: if you don't think respecting SOLID is the best way to go, that's okay. Don't get discouraged!
