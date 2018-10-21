---
layout: blog
title: How to write SOLID code?
---

# How to write SOLID code?

## Embrace and face the change, or it will ruin your code anyway.

One promise of [Computational Biology](http://www.cbd.cmu.edu/about-us/what-is-computational-biology/)
is to develop reliable software of interest for a wide range of biological problems.

Often in Biology, each new problem is a bit different than the previous one,
and the code has to evolve for various possible reasons:

  * to adapt to **this new biological material**
  * to account for **this new model assumption**
  * to integrate **this new super-fast algorithm**
  * to tackle **this super-modern data format**
  * to scale the performances with **this huge new database**.

It is equivalent to say that, in Science like in Industry,
[there is no such thing as frozen specification]( {{ site.url }}/pages/under_construction.html):
very soon the requirements will change.

As soon as the requirements change, the code has to adapt or it becomes outdated.

Because updating code is (very) costly, changes in code requirements can cause the death
of the code bases that did not allow an easy integration of the required extensions.

**Rigid outdated code in science is a dead code.**

**Well-designed outdated code has at least a chance to survive by being updated.**

Writing code that is resistant to changes has been widely discussed in the Industry
the last decades. As scientists who write code, *we need to be aware of the
solutions* found by software engineers.

**S.O.L.I.D. is one of these solutions**.

## A set of common-sense guidelines

### The good understanding

S.O.L.I.D is an acronym representing
**five core principles for object-oriented programming**, largely considered as
one of the most important acronyms in object-oriented design.

It designates five principles initially identified by Robert Martin in the late
1990s as cornerstones of sound class-level design. Together, they
allow developers to identify problems more clearly, to reason and to communicate about the
**feelings we have of a clean or a bad code**.

When an application is perceived to suffer from [bad design symptoms]({{site.url}}/pages/under_construction.html)
(the code is hard to modify, hard to test, hard to fix, breaks everywhere all the time...), we generally
have **an intuition of the root of the problem**:
 * *Oh man, this class is too big, I cannot understand how it works!*
 * *This code base is a total mess of interdependent modules, it's impossible to debug!*
 * *Why the hell should I modify your source code to add my new feature? I don't have
   time to understand your code!*

But we **do not know how to act**, as we do not know how **formalize** these intuitions
into a set of core rules that should be respected to make the code easier to work with.

SOLID does exactly that for us. When a code is hard to work with, it generally
turns out that several of these principles (or even all of them) are violated.
Refactoring the application to respect these
principles generally leads to better feelings about the code.

### The ugly definition

* [**S - Single Responsibility Principle**]({{site.url}}/pages/under_construction.html):
  Each class should do just one thing, but do it well.
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
  and I don't think we should spend days trying to fully understand them *theoretically*
  (I personally still struggle to understand the implications of the Dependency Inversion Principle).

  But we should be aware of the core ideas SOLID expresses, so when having code issues we can analyze
  and react:
  > "Oh, this mess is just me ignoring the Single Responsibility Principle again!
    Let's refactor the code to break down complexity and be able to commit a bug fix!"


## Does it work?

There is no formal proof that these principles actually work, but
accumulated experience of the developers community (including my own) shows that,
**better design and less problems result from writing code that respect S.O.L.I.D.** principles.

Consequently, they are not meant to be absolute rules to follow at any cost, but are
rather meant as good advice and practical heuristics:

> They are common-sense solutions to common problems. They are
common-sense disciplines that can help you stay out of trouble.
[Martin, 2009](https://sites.google.com/site/unclebobconsultingllc/getting-a-solid-start)

When an entire scientific community has achieved consensus on a solution, as researchers we
trust the solution and say "*oh, look, it works!".

**SOLID** principles have achieved consensus in software development
communities: perhaps should we give them some credence.

## Some advice

So if I have an advice to give, it is to:
* First read the SOLID principles description, try to have at least an intuition
  of the problem/solution they describe. We are half programmers, and SOLID is a **basics**
  of programming.
* Then learn to identify the moments **when** you are struggling with your code
  and **the reasons why**: does your code suffer from bad-design symptoms? Is it **rigid**? **fragile**?
* Try to link your code problems and your guts-feelings to a SOLID principle. Ask help online.
* Plan the refactoring to fix your problem: for example if the D.I.P is not respected, divide
  this big ugly mammoth class into several smaller independent ones (if necessary, ask help on the online communities!)
* Trust yourself: if you think respecting SOLID is the best way to go (ask online
  to build confidence and take an informed decision!), then go and stick to it!
