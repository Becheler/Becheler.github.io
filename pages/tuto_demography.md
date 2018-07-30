---
layout: quetzal
title: Quetzal Tutorials
tagline: the C++ Coalescence Template Library
description: Forward-in-time demographic simulations tutorial
---

# Demographic simulation hypothesis

There are two main ways to simulate the expansion of populations of individuals
in a discrete landscape.

## Individual-based dispersal in small populations

For the biologist, the most intuitive simulation behavior would be that each individual
disperse independently. Accordingly, we defined a demographic expansion algorithm
where the location of each individual after the dispersal event
is sampled in a distribution (a dispersal location kernel).

### Pros
This is a comfortable simulation model, as it guarantees without tricks that the number of
individual in a deme is always an integer: simulating the coalescence process is then straightforward.

### Cons

This solution is **computationally costly** whenever the number of individuals
in the landscape is too high.

Unfortunately, we typically have little control over this constraint, due to the
ABC random sampling of parameters value, this is why we implemented an other version that does not have to loop over all
the individuals in the landscape.

## Mass-based dispersal for big populations
