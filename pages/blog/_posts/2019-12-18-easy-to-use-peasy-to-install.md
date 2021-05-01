---
layout: blog
title: How to make a library EZPZ?
---

# How to make a library easy-to-use, peasy-to-install?

Hum, let's be realistic I did not met my goals: instead of writing every two weeks,
it seems that there was one-year gap in the posting pace. One reason to this was
I could not find something relevant to publish: they are already so many awesome
resources about so many aspects of developments! But quite recently I came to a
problematic that is quite new to me: how to make a program accessible to
non-developers.

> Yeah, you can laugh, it's fine.

But *seriously*, it's a complex question. And in academia, we don't always have the
technical support to help us grasping why the question is so complex, why there is
no direct solution, and how we should proceed once we identified that Cmake was part of
the solution.

They are many wonderful resources available online concerning Cmake,
but I did not find the resource I was looking for: it was either too vague,
or to precise, not always intuitive and not very funny to read. Most of the resources
I found were super technical tutorials: you type things like find_package, target_link_library
or install, it seems to work for the example but fails for your project, and you
still don't know what a package or a target is, and what an install is supposed to do.
You don't even exactly know what you are trying to achieve.

If you recognize yourself in these lines, I hope
these posts will be useful to build some intuition before to go towards more in-depth tutorials.

## Motivations

Why did this problematic become real only now? The reason is that I was the only user (and
maintainer) of the C++ [Quetzal simulation library], and I was using it to test
some programs susceptible to bring one or two things new to my field. And I had
*everything I needed on my system*
for these programs to work properly: recent compiler enabled for C++17, external
libraries, external programs...

But (un)fortunately one program became interesting enough to be published
and a demo to be presented in a conference. Gasp. It was suddenly time to write instructions
for an user to set-up correctly the environment... Re-gasp.

> It was a nightmare  

We've heard it all before:

>Install *this* program, and *that* library, beware to use the version
compiled for your OS, and also you will need the version 6.6.6
of *this* other library, and don't you forget to download these 37 github repositories,
and you may also need to modify *this* script if need this output, but if you just want to
use *this and this and this features* you don't need to. And also these guidelines
are written in 2019, so if you read this in 2021, it may not work anymore,
and by the way I left the project so good luck xoxo.

Let's be honest, the user would never survive through the first line of instructions.
And even if I won't be in the room at the moment of the presentation, I feel morally
responsible for the mental health of the attenders. I personally hate having to spend hours setting
a whole ecosystem for a small program to work: why should I expect patience from my users?
And besides, why do I even feel so frustrated? My guess is that despite 5 years of coding,
I may have unconsciously internalized a very wrong statement:

> If it's conceptually simple, it is technically trivial.

That's not true. Technique does not care about humans approximations. Of course we would
like to be able to focus on the biological aspects of the programs we use. Concept A,
process B, output C, result D. TAADAAAA! Done. Publish.

But, even if it is scientifically
admitted not to think too much about dependencies, compilers versions, flags,
linking errors, architecture and others boring stuffs, it does not make this noise magically
disappear. We technically **still have** to care about these details **at some level**.
And of course the relevant level does not have to be the poor innocent user:
the real challenge is actually to hide these details from him.

> Almost nothing is trivial per se. Much work is needed so something useful and complex
can be turned into something useful and trivial. It's engineering: it requires knowledge, skill, time and practice.

Yup. Actually, computers today are like living organisms. A post-doc trying
to design a C++ project susceptible to run without troubles on
any computer is quite similar to an intern trying to design a vaccine for 10 diseases that work on 99%
of the patients. Patience. Humility. Deep breaths. Is 90% negotiable?

Let's try it anyway!

## What you are aiming for: modularity

conference français

- independent modules
- transitive dependency
- compilation flags

## The superbuild pattern



The ExternalProject_Add creates a target that will drive pulling an external project. This means that downloading, building and installing of an external project happens during a build step. As a consequence external project's properties are not known at configure step, so you cannot directly depend (or find_package) on it.

The solution is to use the so called super build. The idea is to use find_package in your project for dependencies as if they were installed on the system. Then you create another CMakeLists.txt which contains ExternalProject_Add instructions for all dependencies and for your project.

When you invoke cmake on super build's CMakeLists.txt it will only setup a build system for downloading and building all the projects but do nothing yet. When you invoke build, the projects are downloaded, configured, built and intstalled one by one. So when it comes to your project all dependencies will be already installed and the configure step will succeed.

Example of super build can be found here (I did not try it, but at least you can get the idea): https://github.com/Sarcasm/cmake-superbuild. Note, that last instruction in cmake/SuperBuild.cmake is ExternalProject_Add for main CMakeLists.txt (aka your project).

See also the CMake documentation at https://cmake.org/cmake/help/v3.10/module/ExternalProject.html for how to define dependencies on an ExternalProject level.

# Questions

installer une lib, ça veut dire quoi concrètement ?

> Installer une bibliohèque, cela revient ni plus ni moins à copier l'ensemble des fichiers générés dans le dossier dans lequel l'utilisateur souhaite pouvoir y accéder
