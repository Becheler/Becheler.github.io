---
layout: tutorial_post
title: Getting started
tagline: the C++ Coalescence Template Library
description: getting started with Quetzal-NEST Docker container
img: logos/quetzal-nest-thumbnail.png
use_math: false
---

Given that ultimately you want to write, compile and run a bunch of C++ code files, you will need the right arsenal! In this tutorial you will download the tools (gathered in a container) that you need to use Quetzal-CoalTL.

# What do we need?

So the first thing you will need is a **terminal**, and the second thing is ... **a nest**!
And by nest, I mean some kind of environment that is suitable to the development of
our Quetzal younglings.

To successfully grow the little programs I sowed across these tutorials, many things are actually required:
- a compiler
> to read our human code and translate it to the machine

- all the source code of the Quetzal library
> *this*, my friend, is the code **you will not** have to write!

- and some dependencies
> *this*, my friend, is the code **I did not** have to write!

To make things a bit easier for everybody, these things have been packaged into a
portable environment: **Quetzal-NEST**. Think about it like a tiny virtual machine that can run on *your* machine. There are many ways to do this, but a popular option is to use *Docker*.

## 1 - Install Docker

Go there and simply follow the instructions: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

#### Some vocabulary:

Working with Docker, you will bump into words like **images** and **containers**. They sound a bit similar, but it's quite important to know the difference between them.

- A **Docker image** is like a recipe  (a template) for cooking an environment: it is read-only, it is inert, it has instructions. You will see that there are several *layers* in an image: these are just a bunch of read-only files that contain the recipe instruction.
- A **Docker container** is like the cake you just take out of the oven: it is a virtualized runtime environment that is (to some extend) isolated from your system. Just as you can make several cakes using the same recipe, you can make several containers out of a Docker images: a container is  an *instance* of a Docker image.

> Read more about the differences between Docker images and Docker containers [here](https://www.whitesourcesoftware.com/free-developer-tools/blog/docker-images-vs-docker-containers/)

## 2 - Install Quetzal-NEST

I created the Quetzal-NEST Docker repository to host, deploy, test and run the Quetzal framework.
Really, it is just a bunch of files that configure an environment where we have all the tools we need for this tutorial.

- To download this big boy on your local laptop:
```bash
docker pull arnaudbecheler/quetzal-nest
```
- Then, you want to run this environment by typing:
```bash
docker run docker run -it --entrypoint bash arnaudbecheler/quetzal-nest
```
- You can look around by typing usual bash commands like `ls` or `mkdir`.
- Try to create a folder in the `home` directory:
```bash
cd home
mkdir sandbox
```
- You can exit the container any time with `exit`: you will go back to your own system and the modifications you made in the container will be lost.

## 3 - Celebrate!

Rejoice, my friend, YOU have entered the nest!

As a welcome gift, here is a small list of commands I use often with Docker:


| Bash command    | Effect        |
| --------------- | ------------- |
| `docker --help` | a must-have!  |
| `docker images` | lists all images (the recipes) |
| `docker ps -a`  | List all containers (the cakes)|
| `docker rm <container>`  | Remove a container |
| `docker run -it --entrypoint bash <container>`  | start a bash terminal *in* the container  |

You know now how to get access to all the tools you need to begin coding with Quetzal-CoalTL!

Ready to lay some good (and bad) EGGS in the next parts of this tutorial?
