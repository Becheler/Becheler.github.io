
# About me

## Current position
I began my PhD in January, 2015, under the direction of Stephane Dupas (EGCE)
and Camille Coron (Laboratoire de Mathématiques d’Orsay), in the DEEIT research team.

## Research interests
I’m interested in modelling the relationship between environment, demography and
genetics in spatial and temporally heterogeneous environments. This kind of models
would allow to shed light on the ecology of a species (dispersal abilities, growth
  capacities…) from observational data, genetic data, and environmental data.

Under such (complex) models, traditional inferantial tools are useless, because
the likelyhood function is intractable. Thus Approximate Bayesian Computation  
(ABC) is a natural way to tackle this kind of model. This method involves
simulating many dataset under the model, exploring various combinations of
parameters values. At the end of the simulation process, confronting simulations
to real data allow to discard all the parameters set having lead to aberrant
simulation results, while trusting in parameter values having lead to simulated
data close enough to the real observations.

An application of this model (still in development) is the inference of biological
features of the Asian hornet (Vespa velutina) in France, an invasive species
causing damages to beehives.

## C++ programming

The need of massive simulations justify my principal activity of C++ programming.
I developed QuetzalCoaTL (Quetzal, the COALescence Template Library), a C++
template library for simulating coalescence processes in spatially explicit
landscapes with complex demography.

# Quetzal

## What it is :
If you are a scientist interested in studying how populations grow and spread in
complex environments using Approximate Bayesian Computation (ABC), this library
can help you.

It offers you some useful tools for building complex generative models of genetic data.

It aims at being **fast**, **modular** and **extensible** so you can use its generic
components when facing issues not tackled by the existing coalescence programs.

## What it is not :
This is not a program, but a library, so you need some basic knowledge about C++ to use it.
The benefit is that you can integrate the existing simulation tools with your own code
much more efficiently.

The code is avalaible on github : just check [this repository](https://github.com/Becheler/quetzal) !

You can visit our [wiki](https://github.com/Becheler/quetzal/wiki) !

You can see the [documentation](/quetzalAPI/html/index.html),
