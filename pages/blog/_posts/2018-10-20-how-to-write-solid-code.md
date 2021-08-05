---
layout: blog
title: How to write SOLID code?
author: Arnaud Becheler
featured_image: solid.jpg
excerpt_separator: <!--more-->
---

One promise of [Computational Biology](http://www.cbd.cmu.edu/about-us/what-is-computational-biology/)
is to develop reliable software of interest for a wide range of biological problems.
But often in biology, each new problem is a bit different than the previous one, existing code has to evolve for various possible reasons: to adapt to **this new biological material**, to integrate **this new super-fast algorithm**, or to scale performance with **this huuuuge dataset**. It is safe to say that in science, like in industry requirements do and will change at some point.
As soon as they do, the code has to adapt or it becomes outdated. And S.O.L.I.D. can help!

![lost in translation]({{ site.url }}/draw/solid.jpg)

### We need a set of common sense guidelines

Because updating code is (very) costly, changes in code requirements can cause the death of
code bases that do not allow an easy integration of new and required extensions.

> Rigid and outdated scientific code is dead code.
> Well-designed outdated code has at least a chance to survive by being updated.

Writing robust code has been widely discussed by software engineers in industry
within the last decades. They have honed in on the principles of writing robust code: **S.O.L.I.D.** As scientists who write code, *we need to be aware of these solutions.*

S.O.L.I.D is an acronym for
**five core principles in object-oriented programming**, largely considered as
one of the most important acronyms in object-oriented design.

It designates five principles initially identified by Robert Martin in the late
1990s as cornerstones of sound class-level design. Together, they
allow developers to identify problems more clearly and to reason and to communicate their
**intuition regarding clean or bad code**.

When an application demonstrates [symptoms of bad design]({{site.url}}/pages/under_construction.html)
(the code is hard to modify, hard to test, hard to fix, breaks everywhere all the time...), we generally
have **an intuition of the root of the problem**:
 * *Oh man, this class is too big, I cannot understand how it works!*
 * *This code base is a total mess of interdependent modules, it's impossible to debug!*
 * *Why the hell should I modify your source code to add my new feature? I don't have
   time to understand your code!*

Yet we often **don't know how to act**, as we don't know how **formalize** these intuitions
into a set of core rules that should be respected to make the code more robust.
**SOLID does exactly that for us.**

When code is hard to work with, it generally turns out that several of these
principles are violated. Refactoring the application to respect these
principles generally leads to better feelings about the code.

##  The Five Principles in short

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
