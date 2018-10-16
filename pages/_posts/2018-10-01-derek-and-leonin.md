---
layout: blog
title: A new blog about coding, seriously?
---

{{ page.date | date: "%d %B %Y" }}

## A new blog about coding, seriously?

Definitely!

But here you will not learn *just* about coding.

If, like me, you come from an academic background like Ecology and Evolutionary Biology,
perhaps you were not taught about **design** and **code principles**.

We learned how to write 200-300 lines of code to analyze data, and most of the time
it is sufficient to our needs.

But not all code projects in science are that short,
and unfortunately principles that work in developing short scripts do not scale with
larger projects.

It raises an important question familiar to software engineers:
**How to not get lost in thousands of lines of code?**

![lost in the code]({{ site.url }}/pictures/lost_in_the_code.jpg)

As methods in Biology become more and more computational, the amount of code
underlying modern research activity becomes actually *huge*.

Getting familiar with the culture of software engineering is not absurd anymore if
we want our tools to handle the complexity of present and future biological questions.

If you are directly or indirectly confronted with some coding project,
general knowledge about coding principles can:
- make your programming activity easier
- better anticipate your computational projects.
- help you understand better the activity of your fellows coders

## Software design? What on earth is that?

Design is something that can seriously ease your life when it comes to writing thousands of
lines of code for a scientific project, and still conserve structure and clarity.
In other words, it can help you avoid your code turning into a scary network of
interdependent functions: I am of course talking about the well-known
[spaghetti code syndrome](https://en.wikipedia.org/wiki/Spaghetti_code).

![Leonin in spaghetti code]({{ site.url }}/draw/leonin_in_spaghetti_code.png)

Design was essential for me in building a code base solid enough to be
extended or reused across multiple projects.

## Is design so important? It seems so abstract!

### Back to the old days

Well, I lost almost one year of my PhD because I coded a simulation project with
almost zero knowledge of software design.

At some point, the code was just too big, too rigid and too unstable to evolve
further. I was unable to bring the required modification without
breaking everything. Dead end.

I contacted software developers who **helped me understand what the hell was going
on in the code** and helped me finding a better design.

It was unfortunately too late to save the old project (R.I.P. little code!) and I had to
delete **everything** I had previously coded: thousands of code lines.

Back to square one. That was not my best day.

![this day leonin understood the term rigidity]( {{site.url}}/draw/this_day.png )

I understood the terms **rigidity** and **code dependency** the hard way!

I started all over again, but this time *in the right direction*!

**On an online developers community**, I began to ask each time I was not sure about
the best (the less quick and dirty) way to code a feature or another. Thanks to their
help I was little by little able to acquire some sound knowledge about design.

The code has involved a bit less rapidly, but with much more stability and reliability!

So yes, design is important. Absence of design had in my case rather ... concrete consequences!

### Never again!

At the time of my PhD, it would have been
a dream come true to have access to a resource warning me **I was
missing something crucial**!

I did put huge efforts on training, though.

From books, online tutorials and web pages accessible from my scientific cultural
sphere, I could learn how to use variables, functions, classes...

But at some point in the learning curve I reached the **limit
of the information** that was accessible from my academic culture.

I needed information related to engineering culture to answer my research problem
in ecology, but the cultures are still very partitioned. I am convinced we need
to collaborate.

This is exactly the purpose I want to give to these pages: contribute to bridging
this gap by presenting a number of facts and **design principles** that I should have known three
years ago!

![Leonin broke his code today]({{ site.url}}/draw/i_broke_my_code_today.png)

## Two hats, one head

As I expect the average reader to have two hats (researcher/programmer),
I will try to maintain two styles across these pages:

- An intuitive, big-picture(ish) presentation of problems and solutions
for the researcher in Ecology & Evolution.
- A more thorough, technical style illustrated with C++ code for the programmer.

Here come **Derek** the programmer and **Léonin** the researcher, two charming/grumping characters who will
have much fun in animating the speech.

They use to have different views and priorities making their collaboration somewhat... fascinating.

![Derek and Leonin collaborating]( {{site.url}}/draw/derekleonin.png)
