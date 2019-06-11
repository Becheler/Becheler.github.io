---
layout: quetzal
title: Quetzal Tutorials
tagline: the C++ Coalescence Template Library
description: Basic Coalescence Simulation Concepts
use_math: true
---

# Basic Coalescence Simulation Concepts

## Reconciling intuition with mathematical assumptions

All coalescence models rely on an underlying demographic process.

We all have a pretty good intuition about real-world  demographic processes: births occur at some rate, with some
mortality during the young stages, then individuals move around, reproduce, and die.

Some demographic models can be quite complex: for example using Quetzal, the coalescence simulation
program can be implemented to account for heterogeneous landscape, temporal environmental variations or weird dispersal forms.

But in other models, the demographic process can be **so simple** we sometimes forget its existence.

For example let's consider a set of haploid individuals. If they disperse
reasonably fast relatively to the size of the geographic area they occupy, then the
geography will have zero effect on shaping the patterns of genetic diversity. In other words we can make the assumption of no spatial structure under some biological scenarios: *No space!*

**No space???**

Sincerely speaking as a student I had quite paradoxically much difficulty
understanding anything in non-spatial models of population genetics, because I was
not always capable to link a given simplifying assumption like *panmixia* with
the rather rigid idea I had of what a population in the concrete world should be: a good
population is a *spatially explicit* population, period.

Linking the idea we have of realistic processes to a formal description
that can be simple enough to be practically implemented is not always straightforward,
notably because some processes can be **very important under some conditions but totally
unremarkable under others.**

This tutorial will make use of a very simple coalescence model to illustrate how some quantities of interest
vary as a function of the model parameters, and how some processes can become totally invisible at
some scales. You will then be able to get why some model details can be dropped to build a better vision
of the most important processes shaping genetic diversity.

Hopefully, it will allow you to better grasp the why and the how mathematicians derived the
nightmarish - but super useful - variety of formulas haunting the population genetic textbooks.

I hope it will also help you in the future to better decide what model to use for your data.
And also to better understand mathematicians: our communities benefit a lot from mutual understanding.

## The neutral Wright-Fisher model

A central model in population genetics is the Wright-Fisher model, that describes the
evolution of a haploid population through time, by describing how alleles are transmitted between generations.
The model was implicitly defined by Fisher and explicitly defined by Wright.

### Assumptions

This model, defined here for haploid populations, makes a number of assumptions:

- population size is constant in time
- the population described by the model is not spatially structured: panmixia.
- No selection or mutation, i.e. as individuals are equally fitted, their number of
descendants follow the same law.
- Discrete and non-overlapping generations : all individuals reproduce/die at
the same discrete time.

The model can be generalized for variable population size. In that case, these
assumptions allow to define the genealogical process in the following terms: at each
generation $t$, parents die by giving birth to $N(t)$ new individuals that pick their parent
uniformly at random.

### Demographic process versus genealogical process

Under this model, the demographic process is defined **forward in time**. In other
words, the number of descendants is defined conditionally to the number of parents.

In contrast, the genealogical process is defined **backward in time**: each descendant
picks its parent uniformly at random and independently.

Interestingly, it allows to consider each process separately under the neutral hypothesis:
first the demographic process to determine the number of parents and descendants, and second
the genealogical process to assign each child at each generation to a parent at the
previous generation.

This model allows to track back the ancestry of sampled genes or sequences
in the demographic history of the population. As the more similar
genes are expected to find rapidly their common ancestor, it allows to shed light on
the underlying demographic process.

When looking at $n$ sampled genes, some of them may originate from the same
reproduction event in the previous generation, where the parental gene was replicated into several children genes.

**Forward in time**, it looks like a classical *reproduction event*.
But **backward in time and looking at genes lines**, everything happens as if
some of the sampled lines *merged* into a common ancestor: this is called a *coalescence
event*.

Coalescence events lead the building of coalescence trees, where vertices are
common ancestors of children nodes and where edges are ancestry relationship.

### The silliest, slowest discrete-time simulation eveeeer

Let's copy this code in [your favorite R statistical language integrated development environment](https://www.rstudio.com/).


```r
# Haploid population size
N = 10
# Number of sampled gene copies
k = 3
# Upper limit for the plot
tlim = N
# Delay for the animation (in seconds)
delay <- 0.5


freeze <- function(){ Sys.sleep(delay)}
# Sampling time
t= 0

# Plot the haploid individuals of the whole population
pop <- seq(from = 1, to = N, by = 1)
plot(pop, rep(t,N), ylim = c(0,tlim), xlab = "individuals", ylab = "time")

# Simulate in black the sampled gene copies
sample <- sample(x = pop, size = k)
points(sample, rep(t,k), pch=16)

# Loop to coalesce until the MRCA (or to stop when outside the plot)
while(k > 1 && t < tlim){
  t = t + 1
  # Plot the previous population of individuals
  points(pop, rep(t,N))
  freeze()
  # Just to store the parents that have been picked by the lineages
  remember <- c()
  # Iterating over the lineages
  for(child in sort(sample)){ #child = sort(sample)[1]
    # Sample one parent uniformely at random
    parent = sample(x = pop, size = 1)
    # Plot the ancestry relationship between the child and the parent
    segments(x0 = child, y0 = t-1, x1 = parent, y1 = t)
    freeze()
    # Is it a coalescence event ?
    number_of_coalescence = sum(remember == parent)
    if(number_of_coalescence == 0){
      # Nope :(
      points(parent, t, pch=16, col="black")
    }else if (number_of_coalescence == 1){
      # Yes ! :D
      points(parent, t, pch=16, col="blue")
      k = k-1
    }else if (number_of_coalescence >= 2){
      # OMG more than two nodes have coalesced!!!!
      points(parent, t, pch=16, col="red")
      k = k-1
    }
    freeze()
    # Add the parent to the list of already picked parents
    remember<-c(remember,parent)
  }
  # The remaining lineages in the parental generation form the sample of the next iteration.
  sample<-unique(remember)
}
```

Execute the code.

Don't be angry if sometimes the graph gets messy and ugly, the aim was to have the simplest code, not
the prettiest tree!

### Simulation exploration

#### Constant parameters

In this section, $k = 3$, $N = 10$, $tlim = N$

> **Question #1:**
Do you observe coalescence events ? How many ?

Try to re-execute the code. Your results will normally change, it's totally expected: the
model is stochastic.

Try to understand each step of the animation. You can slow down the animation even more
if you want by increasing the ```delay``` variable to 1 seconde or more. From these
genealogical trees, how to simulate genetic data?

> **Question #2:**
Does the simulation output seem to change qualitatively a lot for the same parameters k and N?

I personally got all gene coalescing in one parent after only two generations:

![triple coalescence]({{site.url}}/pictures/triple_coalescence.png)

and just the next simulation no coalescence at all:
![no coalescence]({{site.url}}/pictures/no_coalescence.png)

Try to explore the variability of the trees that this model can generate by trying to *rematch* these results.

> **Question #3:**
Can you compute the probability of these two simulation outputs? A lead: the probability for
two genes to coalesce in the same parent is $1/N$.

It's rather frustrating to have to stop the coalescence process when we get out of the plot.
*If only* we could set a value for ```tlim``` in such a way we are *almost* sure that
the graph contains the Most Recent Common Ancestor of the sampled lineages.

Any idea?

>Under the assumptions of a Wright-Fisher mode, the mean and variance of
the time required to find the Most Recent Common ancestor of the $k$ sampled gene copies are expected to be:
>
>$$
>E[T_{MRCA} = 2.N.\frac{k-1}{N}
>$$
>
>$$
>V[T_{MRCA}] = N^2.(8.( \sum_{i=2}^{k}{\frac{1}{i^2}}) - 4(1-\frac{1}{k})^2)
>$$
> Can you see to this expectations some utilities for those coding simulators?

#### Varying k

Try to set different values for $k$ using opposite situations: $k=3$ and $k=N$.
> **Question #4:**
How does higher sampling density seem to affect the coalescence process? Which aspects of it?

Too many branches make the plot look awful. Maybe you could simplify it: disable the
code responsible for plotting the branches and representing the non-coalescence events.

> **Question #5:**
> Look how the coalescence events are distributed along the generations and how k influences them.
> Look also how greater $k$ values influence the probability of ternary coalescence events.

Try to modify the code so it can store the time at which all genes have coalesced to the MRCA: perform many repetitions under $k=3$ and $k=N$ and compare these distributions.

#### Varying N

Now disable also the parts of the code responsible for plotting the white circles representing the population individuals,
and try to increase $N$ values.

> **Question #6:**
> How do you think that higher population size influences the distributions of coalescence events?

Now, can you add some lines of code so you can store all coalescence times and plot their distribution?

> **The computational cost of "nothing is happening"**
>
>Try very high values like $N = 10000$, $k=100$.
>
>Can you feel the computational cost increasing?
>
> Look at how many generations occur without a single coalescence event simulated: do yo think a discrete-time Wrigh-Fisher model is relevant here?

## The n-coalescent: just another way to look at the same process.
