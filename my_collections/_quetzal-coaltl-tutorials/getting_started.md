---
layout: tutorial_post
title: Getting started
tagline: the C++ Coalescence Template Library
description: getting started
img: schemes/decrypt_sampling_scheme.png
use_math: false
---

In the following tutorials, we will write, compile and run a bunch of things!

So the first thing you will need is a **terminal**, and the second thing is ... **a nest**!
And by nest, I mean some kind of environment that is suitable to the development of
our Quetzal younglings.

To successfully grow the little programs I sowed across these tutorials, we will indeed need many
things:
- a compiler to read the human code and translate that into instructions that the computer can run
- all the source code of the Quetzal library (*this*, my friend, is the code you will NOT have to write!)
- and some dependencies (*this*, my friend, is the code **I** did NOT have to write!)

To make things a bit easier for everybody, these things have been packaged into a
portable environment (think about it like a tiny virtual machine that can run on *your* machine).
There are many ways to do this, but a popular option is to use Docker.

## 1 - Install Docker

Go there and simply follow the instructions: https://docs.docker.com/get-docker/

## 2 - Install Quetzal-NEST

I created the Quetzal-NEST repository to host, deploy, test and run the Quetzal framework.

Really, it is just a bunch of files that configure an environment where we have all the tools we need for this tutorial.

- To download this big boy on your local laptop, all you need to do is to type in a terminal:
```bash
docker pull arnaudbecheler/quetzal-nest
```
That will download all the *layers* that constitute our docker image.
- Then, you want to run this environment:
```bash
docker run arnaudbecheler/quetzal-nest
```

- You can look around by typing usual bash commands like `ls` or `mkdir` or even `./EGG1 --version` (yes! Quetzal-NEST comes with some ready-to-use simulators!)

## 3 - Celebrate!

Rejoice, my friend, You have entered the nest!

Ready to lay some good (and bad) EGGS in the next parts of this tutorial?
