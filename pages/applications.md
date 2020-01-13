---
layout: quetzal
title: Quetzal
tagline: the C++ Coalescence Template Library
description: applications
---

# Decrypt

## Summary

Decrypt is a tool allowing to shed light on systems where cryptic diversity and
isolation by distance are two competing hypothesis. Decrypt can help understanding
if the genetic structure detected under the MultiSpecies Coalescent (MSC) could possibly
be explained by the intra-species spatial structure.

It can be seen as a way to automate MSC robustness analyses for different realistic demographic histories
and sampling scenarios.

Quetzal modules have been here very useful to build the Decrypt C++ demogenetic simulation core,
and along with Quetzal sampling models, it allows to test the inferential impacts of many different sampling
schemes on the MSC model.

<video src="../movies/decrypt_demography.mp4" width="640" height="400" controls preload></video>

## Installation

The following instructions allow to install decrypt on an Ubuntu environment.

### 1 Get the dependencies

We first need to install three main dependencies. The Geospatial Data Abstraction Library (GDAL) is useful to represent a
spatially explicit landscapes. Boost is an important code resource for C++ dev
that covers a wide range of problems. SQLite3 is a lightweight database software
we use to store intermediary results.

Open a terminal and type
```
sudo apt-get install libgdal-dev libboost-all-dev sqlite3
```

### 2- Get Decrypt source code

Two options are possible here, up to you:

#### You are not interested in future Decrypt features

You may just want to download the [latest release of the project](https://github.com/Becheler/decrypt/releases).

#### You want to benefit from further developments

Then you should prefer to clone the github project, so you can update the decrypt pipeline
whenever you want. To clone the project, you need git, so first be sure that git is installed in your system.

To do so, simply open a terminal, type ``git --version`` and press Enter.

If the terminal answers something like ``git version 2.17.1``, it's good: git is already installed.
If it is not the case, then check the [git website](https://git-scm.com/) for proper installation.

Once you have successfully installed git, then open a terminal, chose a suitable
folder in your file system, and type:

```
git clone https://github.com/Becheler/decrypt.git
```

Awesome, the Decrypt source code is now on your computer!

### 3 - Build, test and install

Create a directory ```sandbox``` somewhere on your computer. We will use it
as both an install location and an application directory the time for us to package the software better.

At this point, go to the ``decrypt`` directory, build the project, run the tests and install
the project to the ```sandbox``` location

```
cd decrypt
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=path/to/the/sandbox/directory
make
make test
make install
```

If the tests and the installation end without problems, there is now a directory
``sandbox/decrypt``.

# Application

## Example configuration files

The install location contains an ```example``` directory where
you can find:
- a landscape (a tiff file representing the rainfall in North Australia)
- a configuration file to set parameters of the spatial spatial process
- a configuration file for BPP

## Running the spatial process

In a terminal, go to the sandbox directory and run the following:
```
cd path/to/sandbox
chmod +x decrypt/spatial_process decrypt/bpp
mkdir output
./decrypt/spatial_process --config decrypt/example/spatial_process.ctl
```

If the program runs correctly, you should see in the terminal if the demographic
history has been simulated, and then a progress bar that indicates
how advanced the pseudo-observed data generation is:
```
--- Expanding demography
--- Simulating coalescents

0%   10   20   30   40   50   60   70   80   90   100%
|----|----|----|----|----|----|----|----|----|----|
***************************************************
```

This program creates a bunch of files in the ```output``` directory that give access
to various aspects of the demographic process. We will be able to visualize them
later using the small R library ```decrypt/decrypt.R```. Now we will focus on analyzing
the simulated coalescents that have been stored in the ```output/test.db``` database.

## Performing species delimitation under the MSC using BPP

In the ```sandbox``` directory, create a Python virtual environment to avoid polluting your system, activate it
and install the python dependencies:

```
virtualenv ENV
source ENV/bin/activate
pip install pandas matplotlib seaborn pyvolve
```

Ask what options the ```decrypt/decrypt.py``` program takes:

```
python3 decrypt/decrypt.py --help
```
The output is:
```
Options:
  -h, --help        show this help message and exit
  -d DATABASE       path to database
  -l SEQUENCE_SIZE  sequence_size
  -s SCALE_TREE     scale tree branch length
  -b BPP            path to bpp executable
  -c BPP_CTL        path to bpp config file
```

Run the following command line:

```
python3 decrypt/decrypt.py -d output/test.db -l 100 -s 0.000001 -b decrypt/bpp -c decrypt/example/bpp.ctl
```
It will go through each gene genealogy, evolve sequences along branches and perform
species delimitation on this pseudo-observed data. When the BPP analysis is done,
a dataframe is generated that give for each sampling scheme the probability to detect
more than one species.

We can then use the R library to visualize the results.
