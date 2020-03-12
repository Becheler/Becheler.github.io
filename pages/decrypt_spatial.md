---
layout: decrypt
title: Decrypt
tagline: speciation versus isolation by distance
description: spatially explicit coalescence process
use_math: true
---

# Forward time demographic process

In this tutorial you will learn about the principal aspects of spatially explicit
coalescence models. You will here have a look into the forward time demographic
process to understand how to model the fact that geographic distance and environmental
conditions can affect dispersal and reproduction.
In a second part of the tutorial, you will see how these model features can affect
coalescence process and genetic diversity.

## Modeling life cycles

During a lifetime, organisms can go through many different stages. Some stages may
be very specific to a type of organism, other stages can be heavily impacted by
environmental conditions, other stages can be density-dependent...

> Task: consider your favorite organism and take few minutes to imagine how you would
 model the lifecycle of a single individual:
 - What are the main stages?
 - How much time does the individual stay in each stage? Is there variability?
 - How environmental conditions and other factors affect the survival at each stage?
 - What defines the transition to the next stage?

 Even if it is feasible to include any number of stages in a simulation model, it is
 not always relevant: adding a stage like the *egg* form for an insect:
 - increases the complexity of the model
 - increases the computational time,
 - may require some uncomfortable assumptions
 - reduce the portability of the model to other organisms
 - and can possible add more parameters to estimate like
   the mortality rate during the egg form.

 This can explain why we will consider here a very light version of a generation-by-generation lifecycle:
 - parents reproduce
 - parents die
 - children disperse

Simplest. Cycle. Ever.

It means that reproduction and dispersal will be considered here as the main demographic processes
 shaping genetic diversity: this not always the case!

## Modeling reproduction

### The old example of a bacteria population in an infinite plate.

Consider an initial bacteria that reproduces, having 2 children. The parent dies.
Population size is now 2.
Each child has then again 2 children. Parents die. Population size is now 4...

At this rate, the population obviously colonizes the entire universe. Simple, but
not realistic. There is always a number of factors limiting the expansion of a colony.

> Task:
> In your favorite biological organism, identify some of these factors.
> Imagine how these factors could be integrated in a more formal way.
>
> Alert: spoilers ahead.

### A more formal way to integrate limiting factors: the logistic growth

The logistic function can be used to set a limit to the size that a population can
reach in a given environment. It introduces two quantities:
- the growth rate $r$, related to the average fecundity of the population
- the carrying capacity $K$, that is the maximal number of individuals that can be supported.

The following picture shows how the size of a population changes through time,
with carrying capacity $K=500$, for different values of $r$:

![logistic growth]({{site.url}}/pictures/logistic.png)

### Mathematical description

Let's consider a single population where $N$ parents reproduce then die in an environment
that has limited resources.

A possible expression of the number of children $\tilde{N}$ would be:

$$\tilde{N} = \frac{N.(1+r)}{1+\frac{rN}{K}}$$,

> Type in the terminal:  
> ```
./model_1 --config config_1.ctl --landscape australia.tif
./to_animation.R output/N.tif output/history_1.gif
```
> The first command line runs a demographic simulation across Australia.
> The second command line generates an animation to visualize the results.
> Observe the characteristics of the demographic history:
 - Speed of the expansion front
 - Total population size over the landscape
 - Does the process reach a stable state?
>
> Now copy the configuration file:
> ``` cp config_1.ctl other_config_1.ctl```
 - Open the configuration file and modify the growth rate and the carrying capacity
   to increase or decrease the speed of the expansion front
 - What conclusion can you make?
 - Make a list of your biological systems of interest that match/don't match this model.
 - What aspect(s) of the demographic process could be changed to give a better match?

### Adding environmental heterogeneity

The number of descendants $$ \tilde{N}_{x}^{t} $$ in each deme can be sampled in a
distribution conditionally to a function of the the local density of parents,
for example

$$ \tilde{N}_{x}^{t} \sim Poisson(g(x,t)) $$,

where $g$ can be for example a discrete version of the logistic growth:

$$
\begin{array}{cc|ccc}
    g & : & \mathbb{X}\times \mathbb{N} & \mapsto & \mathbb{R}^{+} \\
      &   &          (x,t)               & \mapsto & \frac{N_{x}^{t}\times(1+r(x,t))}{1+\frac{r(x,t)\times N_{x}^{t}}{K(x,t)}}  ~. \\
\end{array}
$$

The $r$, respectively $k$, term is the growth rate, respectively the carrying capacity,
defined as a function of the environmental quantities with parameter $\theta$:

$$
\begin{array}{ccccl}
K  & : & \mathbb{X}\times \mathbb{N} & \mapsto & \mathbb{R}^{+} \\
   &   &    (x,t)       & \mapsto & f_{K}^{\theta}(E(x,t))~, \\
\end{array}
$$

$$
\begin{array}{ccccl}
r  & : & \mathbb{X} & \mapsto & \mathbb{R} \\
   &   &    (x,t)       & \mapsto & f_{r}^{\theta}(E(x,t)) ~. \\
\end{array}
$$

# Defining niche functions in the simulation model

## Introduction

By *niche functions*, we mean any model quantity that is linked to environmental
quantities.

For example the following function is what we would call a niche function: the growth rate
is a function of the temperature.

![niche function]({{site.url}}/pictures/niche.png)

Usually in demogenetic models, the "true" niche functions are not precisely known,
so their forms have to be inferred. In the previous picture, we would typically try to estimate
the parameters $T_{opt}$, $T_{min}$ and $T_{max}$.

If you are reading this tutorial, it means that you are
probably interested in simulation-based inference: in such frameworks a huge amount of simulations is needed to explore the parameters
space. Quetzal allows to explore the parameter space of the niche functions with
a priori better efficiency than achieved by previous simulation resources.

> Why ?

Typically, an ABC analysis would require:
- the raw geographic dataset to be read and tranformed using an external software with a
  given set of parameters
- The tranformed data to be written in memory
- The transformed data to be read by the demogenetic program to run a simulation.

And this *read-write-read* cycle would repeat *millions of times* as the parameters are resampled.

We advocate that it is a *costly way to compute things*. Instead, we prefer to
integrate the model choice into the demogenetic simulation program, so the data transformations
are computed *on the fly* rather than written in memory. Plus, it fosters scientific reproducibility.

As there are a open-ended number of possible models, and that their relevancy is
very specific to the question at hand, we choose to
leave the user free to define its own niche functions, and we give him the right
tools to do so.




## Dispersal

## Adapting the model to phylogeographic scales

# References

Irwin, K., Laurent, S., Matuszewski, S. et al. On the importance of skewed offspring distributions and background selection in virus population genetics. Heredity 117, 393–399 (2016). https://doi.org/10.1038/hdy.2016.58
