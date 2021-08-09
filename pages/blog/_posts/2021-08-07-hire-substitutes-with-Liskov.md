---
layout: blog
title: Easily pick substitutes in your library thanks to Liskov
author: Arnaud Becheler
featured_image: LSP_basketball.jpg
---

If you made good use of the [Single Responsibility Principle]({%post_url blog/2021-08-06-make-code-surgery-easy-with-SRP %}),
your code should begin to look more and more like a **team of independent but cooperating entities**,
each one having their specific role and their unique qualities. It's actually not
so different from a **basketball team**, where the position of a player on the court is associated to their individual
behavior and qualities. The *point guard* position requires good leadership and considerable
ball-handling skills. You generally want your *shooting guard* to be the best, most accurate
long-distance shooter, your *small forward* to be aggressive, and the *center* to be
the tallest of your team. Also, when one of your best player passes out during a game, you
want to preserve the team alchemy by picking a substitute with similar responsibilities, qualities and behavior.
Similarly in a code project, when one class has to be replaced, the **Liskov Substitution Principle**
(the **L** of the [ S.O.L.I.D. principles]({%post_url blog/2018-10-20-how-to-write-solid-code %}))
can make this step considerably more secured by guaranteeing that this new programmatic
player will interact with its teammates in a way that is comparable with its ancestor.
This is generally enough to make sure that this change will not throw
the entire computer play-field into disarray.

![Léonin having some fun with the library guys]({{ site.url }}/draw/LSP_basketball.jpg)

### A bit of history

The L.S.P was introduced by [Barbara Liskov](https://en.wikipedia.org/wiki/Barbara_Liskov),
one of the first American women to get a doctorate in computer science!
She earned a BA in mathematics at Berkeley in 1961, where she had **only one** other female classmate!
After her graduation she applied to mathematics programs at Berkeley and Princeton,
but Princeton was not accepting female students in mathematics at this time - *sigh*.
She went to Standford, where the topic of her Ph.D. thesis was to develop
the *Huberman's program* to play chess end games
where few pieces play against a lone King. For this, she developed the Killer Heuristics
(*a quite French way to bring down the chess patriarchy*).

### Definitions

With [Jeannette Wing](https://en.wikipedia.org/wiki/Jeannette_Wing),
Barbara Liskov developed a distinct definition of subtyping that can help programmers minimizing
side-effects in our code: the **Liskov Substitution Principle**:

> **Liskov Substitution Principle:**
> Let  *A(x)* be a property provable about
> objects *x* of type **T**. Then *A(y)* should be true for objects *y* of type **S** where **S** is a
> subtype of **T** (Liskov and Wing, 1994).

If you are like me and easily scared by maths, well, I can **ensure** you: there is
nothing intimidating here! **Subtyping** is simply what happens every time you derive a
class **S** from a class **T**.

> *[Derivation (or inheritance)](https://en.wikipedia.org/wiki/Inheritance_(object-oriented_programming))* is
the fundamental mechanism of Object-Oriented Programming that makes possible to reuse (not modify)
old code and to build upon pre-existing classes, rather than entering a copy-pasting frenzy
(what you generally want to avoid).

What Liskov tries to tell us here is that whenever you use inheritance, you should pay extra-attention
to make sure that **any property of the ancestor class remains true in your derived class**. In other words, if you have a big game coming but that you need to replace your *injured center player*, you better make
sure the new guy is at least as tall as their predecessor.

![Derek comes with bad news - and a job]({{ site.url }}/draw/LSP_knock_knock.jpg)

If you are familiar with Object-Oriented Programmming, an alternative formulation of the **L.S.P** that
I find easier to understand is the one that Robert Martin gives:

> Functions that use pointers or references to base classes must be able to use
objects of derived classes without knowing it (Martin, 1996c).

This ensures that you can modify a part of your code and extend its functionalities
without breaking the rest of the application every time you need to substitute an object
by another.

<img src="/draw/LSP_anyone.jpg" alt="Derek asks for a Liskov substitute" width="500" height="588" />

I find the **Liskov Substitution Principle** particularly elegant because it's one of
the few design principles that actually has a formal,
logical definition. Think about how open to interpretation the
[Single Responsibility Principle]({%post_url blog/2021-08-06-make-code-surgery-easy-with-SRP %}) was: it
does not constrain the **definition** of a responsibility, it only constrains the
**number** of responsibilities a class should have. Even if you are **seriously committed** to giving one
and only one responsibility to each class, the actual interpretation of a *responsibility*
is still up to you! And this vagueness is not always a good thing because it leaves room
for mistakes, poor decision making and bad design. Well, with the **L.S.P**,
we don't really have that much space to mess up: its formulations are actually pretty clear.

![Léonin being bullied by the code again]({{ site.url }}/draw/LSP_guys.jpg)

## An application example

### Step 1: The abstract flock

Imagine you developed a library to simulate birds migration.
You proudly declared a base class `Bird` to generalize the concept of bird, making your
brilliant code applicable to any kind of bird:
```
class Bird{
    fly(){}
}
```
Somewhere else in your library, you can use this abstraction in a function
to represent the dispersal of a population of birds towards new habitats.
This generalizes the dispersal process to any kind of bird:
```
function disperse_all(){
  for each bird in population){ // where population is e.g. a list of Bird pointers
      bird.fly()
  }
}

```
Brilliant!

### Step 2: The very concrete Duck

But your research is not about **abstract birds** at all!

Actually, your first project is about the very concrete, nomadic
[Pacific Black Duck](https://en.wikipedia.org/wiki/Pacific_black_duck)
(*Anas superciliosa*).

This duck has pretty weird dispersal patterns: individuals
randomly disperse when there is a flood, but tend to stay sedentary on permanent waters.
But in Northern Australia they tend to spend the dry season (winter and spring) on the coast,
but then migrate inland when the summer monsoons come. In short, a pretty ~~undecisive~~ interesting bird you want
to apply your code to!

So you begin the code extension by deriving a class from the Bird base:
```
public class PacificBlackDuck extends Bird{}
```
This brand new class gives you all the space you want to **hide** all the weird ecological details of the
Pacific Black Bird: you will certainly add few data members to store the species ecological preferences and
add some member functions to implement their ~~weird~~ unique quacking and mating behavior.

And you run your code.

Because  `PacificBlackDuck` is derived from `Bird`, it automatically inherits
its public method `fly`: the function `disperse_all` has access to everything it needs when
it calls `bird.fly()`. Your code executes perfectly: it prints some results in the terminal,
and you walk with an **immense pride** towards your PI's desk to show off your results.

It was a very remarkable benefit of the *L.S.P*: **Since the Pacific Black Duck IS a bird,
whenever your code needed an abstract Bird it could also run properly with a Pacific Black Duck**.

### Step 3: The distracted folk: "Fly little ... kiwi?"

Imagine that after you published the study of the Pacific Black Duck, you are
are now faced with conducting the same analysis with the **Kiwi** dataset (the bird, not the fruit).

You follow the same logic and write:

```
public class Kiwi extends Bird{}
```

Unfortunately, there is a big caveat here! The `Kiwi` class will inherit from
the `fly method`. But trying to call `fly` on a `Kiwi` makes makes **no sense**
since it's a flightless creature! That so lame! In the present state,
the logic of the code is actually ill-defined! Yeah I know, how disappointing. Let's fix that.

Of course your first instinct will be to test if the bird at hand is a `Kiwi`, and if
so, to call the method `hop` rather than `fly` in the `disperse_all`. Well, I hope
Derek did not hear you saying this. It's called [Runtime Type Information (RTTI)](https://en.wikipedia.org/wiki/Run-time_type_information).
and it's generally **NOT** a good idea: trying to identify the real type of an object in order to call the appropriate function
is a common violation of the **LSP**. It would also clearly violate the [**Open Closed Principle**]({{site.url}}/pages/blog/under_construction.html), since the `disperse_all` code would have to be modified each time that a new derived class (*e.g.,* a `Penguin`) is added.


### Step 4: The "tadaaaa"

What the **L.S.P.** says is that if you want to avoid big problems,
you should instead refactor your code to preserve its conceptual integrity by
defining a clear hierarchy of concepts!

```
class Bird{}
class FlyingBirds extends Bird{
    fly(){}
}
class PacificBlackDuck extends FlyingBirds{}
class Kiwi extends Bird{}
```

And tadaaaa ! You end up with few more classes, but a much more consistent logic. More
importantly, your code is:
* more **robust**: *it will not break when you will need a penguin*
* more **maintainable**: *you will not have to modify existing code every time you study a new bird*
* more **reusable**: *an external user will be able to reuse your algorithms with their own birds without having to modify the code you wrote*

Thank you Liskov!

![Léonin en route fo the cluster]({{ site.url }}/draw/LSP_tragic_mistake.jpg)

## Found on Derek and Léonin's bookshelf

* [“Design principles and design patterns” - Martin, Robert C. (2000)](http://staff.cs.utu.fi/staff/jouni.smed/doos_06/material/DesignPrinciplesAndPatterns.pdf)

* ["Coder efficacement : Bonnes pratiques et erreurs à éviter (en c++)" - Philippe Dunski](https://www.amazon.fr/Coder-efficacement-Bonnes-pratiques-erreurs/dp/2822701660)
