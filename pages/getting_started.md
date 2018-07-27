---
layout: quetzal
title: Quetzal
tagline: the C++ Coalescence Template Library
description: getting started
---

# Get started with the Quetzal project!

Here we give some guidance to install Quetzal and its dependencies for Ubuntu and Mac OSX users.

## 1- Get the source code

To include source code in your own project, you need to have it available on your computer.

Two options are possible, up to you:

### You are not interested in future Quetzal features

You may just want to download the [latest release of the project](https://github.com/Becheler/quetzal/releases).

### You want to benefit from further developments

Then you should prefer to clone the github project, so you can update the Quetzal
library whenever you want. To clone the project, you need git, so first be sure that git is installed in your system.

To do so, simply open a terminal, type ``git --version`` and press Enter.

If the terminal answers something like ``git version 2.17.1``, congrats: git is already installed.
If it is not the case, then check the [git website](https://git-scm.com/) for proper installation.

Once you have successfully installed git, then open a terminal, chose a suitable
folder in your file system, and type:

```
git clone https://github.com/Becheler/quetzal.git
```

Nice, the Quetzal source is now on your computer.

> **Tip of the day #1:**
In a near future, to benefit from a later version, you will surely want to type the following in the terminal:
```
cd quetzal
git pull
```
This will automatically retrieve the last code updates.

## 2- Get a decent C++ compiler

Quetzal is a C++ template library, so obviously you need a C++ compiler. Quetzal
makes use of modern template techniques for which a compiler with a strong template support
is needed.

Basically, this is simply not the case for compilers versions prior to 2003, so make sure you have a decent version.

We use ``g++ 7.3.0`` in our projects, enabled for C++17 features.
> **Tip of the day #2:**
To enable C++17 support, add the command-line parameter ``-std=c++17`` to your g++
command line when you will compile your programs.

## 3- Get the dependencies

Quetzal uses some external libraries to make things easier and faster. Be sure
dependencies are installed.

### Install the Boost libraries

Boost is a big resource for C++ devs. It is a set of libraries (more than 80!) that
cover a wide range of problems. We use them here and there when necessary.

**Ubuntu**

Open a terminal and type
```
sudo apt-get install libboost-all-dev
```

**Mac OSX**

According to [Mac App Store](http://macappstore.org/boost/),
you can get the latest version of boost using [Homebrew](https://brew.sh/):
```
brew install boost
```

### Install GDAL, the Geospatial Data Abstraction Library

The Geospatial Data Abstraction Library (GDAL) is essential to represent a
spatially explicit landscapes. We need the GDAL sources enable interactions with
Quetzal features, so make sure you have the dev version:

**Ubuntu**

Open a terminal and type
```
sudo apt-get install libgdal-dev
```

**Mac OSX**

Visit [GDAL website](https://www.gdal.org/) for proper download.

## 4- Check that everything works

Open a terminal, go in the ``quetzal`` directory and type:

```
./run_test.sh
```

If all the tests end without problems, it means you are ready to go!

If you have any trouble, feel free to contact us.
