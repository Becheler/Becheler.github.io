---
layout: quetzal
title: Quetzal Tutorials
tagline: the C++ Coalescence Template Library
description: tutorials
---

Welcome in the Quetzal tutorials!

The website is still under construction, so things are missing. But whenever the tutorials
will be set up, you will learn about the following:

# Coalescence basics with R

Maybe are you not familiar with coalescence-based models: hopefully these resources
will help you becoming familiar with the basic concepts around coalescence simulation.

[SillyCoal: the silliest, slowest simulator ever](tuto_R_sillycoal.html)


# Forward-in-time demographic simulations

[How to use different strategies for simulating populations dispersal:](tuto_demography.html)

- Individual-based dispersal in small populations
- Mass-based dispersal for big populations

[How to integrate landscape heterogeneity in the analysis with GIS:](tuto_geography.html)

- For retrieving a demic structure
- For constructing multivariate, spatially explicit, temporally changing landscapes.

[How to construct niche functions](tuto_niche.html)
- Enable mathematical composition of functions of space and time using expressive
- Coupling environment, growth model and stochastic sampling.

 How to represent dispersal models:

  - using library-defined distance-based dispersal models
  - implementing user-defined dispersal models

# Backward-in-time coalescence simulation

How to think about coalescence graphs:

- using user-defined data structure (that is, the graph nodes)
- using user-defined ancestral relationship (that is, the graph edge)

How to coalesce forests in a spatially explicit framework

- using the Kingman coalescent approximation (binary merges)
- using the multiple merger for small populations

# Approximate Bayesian Computation

How to define estimate the parameters of any model:

- learn how to build a Quetzal generative model
- learn how to parametrize this model
- learn how to construct a prior distribution
- use the ABC module to run inference
