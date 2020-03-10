---
layout: decrypt
title: Decrypt
tagline: speciation versus isolation by distance
description: intuition
use_math: false
---

This part of the tutorial presents some basics for readers
who would be unfamiliar with the coalescence process.

# What is coalescence?

Imagine a population of haploid individuals. They reproduce and die, and their children
take their place. Even without considering natural selection, some individuals
may randomly have few more children than others, transmitting a copy of their
own genetic material to the following generation. Consequently, the genetic composition
of the following generation may be slightly
different from the previous one, even if no mutations happen. This is a well-known process
that we intuitively understand forward in time:

![]({{site.url}}/pictures/decrypt/fig1b.jpg){:height="30%" width="30%"}

*Evolutionary process of whole population. Adapted from Irwin et al. (2016).*

> **Task**
 - Take a look at the previous figure.
 - Does it look like a coalescent tree? What is different?
 - Reconstruct the distribution of the number of children for few generations.
 - How does it affect the genealogical process and the population diversity?
 - What population parameter would you change in this example to attenuate this effect?

Modeling a process forward in time is not always relevant. For example,
think about simulating data: we would need to simulate a whole population of
individuals and their genetic material in order to simply sample a small fraction of the
whole population. It's not very convenient.

John Kingman developed the idea that it may actually be more elegant to track the
lineages of a set of sampled gene copies *backward in time* until they find their common ancestor.
The demographic processes (reproduction rate, migration...) stay the same, only the perspective changes: rather than
following the genetic evolution of a whole population, we simply look at how the
genetic diversity of the sample *only* has been shaped by the demographic history.

**In this framework, a coalescence event is simply the replication of the DNA, viewed backward in time.**

It means the two following views are equivalent:
- imagining a parent making copies of its genes and sending them to an uncertain future, meaning that some lineages may die.
- for a set a sampled gene copies, reconstructing the history of replications events (when and where the parental copies are found?)

Instead of following all the lineages inside a population from the past to the present,
we track the past history only of the lineages that we sampled: it gives a clearer picture
of the lineages of interest:

![]({{site.url}}/pictures/decrypt/fig1b_complete.jpg){:height="40%" width="40%"}

*Evolutionary process of whole population. Adapted from Irwin et al. (2016).*

> **Task**
 - Does this tree better match your expectation of a coalescent tree?
 - Look closer at the number of branches: why do you think that usually coalescent trees are represented as binary trees?
 - WHat assumption do you make by choosing to track only the sampled lineages and not even consider the others?

# Fifty shades of gene trees

We are generally interested in characteristics of the lineages trees that are generated under
such demographic processes:
- number of branches in the tree
- their lengths
- the time to the root of the tree,
- or also the number of merges (how many branches are connected to a same node).

These quantities will be referred as *genealogical properties*: they are useful
summaries of a genealogy (trees are quite complex structures when one thinks about it...)

Because reproduction is stochastic, we may never generate twice the exact same tree. That is, the genealogical properties
don't have a fixed value under a model, and they are instead better described by probability distributions: under a given demographic history, some values of these quantities may be more likely than others.

Along the years, mathematicians have produced a (large) number of formulas to describe these distributions
(expected values and the dispersion around these values). Generally students are taught
about the simplest models (*e.g.* Wright-Fisher with or without migration). It is important to
keep in mind that a given formula (for example the expected time to the MRCA) is
linked to a particular demographic model, that implies a number of assumptions.

> **Task**
 - List the formulas you learned in class.
 - What quantities do they describe?
 - From what model have they been derived? List its assumptions.
 - What could be the most important consequences of an unmet assumption?

# Inference

Different demographic models may differ by their ability to produce different shapes of gene trees.
- isolated population with constant size
- demographic fluctutations in a population
- network of sub-populations connected by migration
- metapopulation in an heterogeneous landscape

Model choice can be straightforward if the biological system is well-known.
Sometimes it can also be unclear if one model should be preferred over another, and selecting
the model that allows to best represent the data can then become an important part of the inference process
([*model selection*](https://en.wikipedia.org/wiki/Model_selection)).

These models are generally parametrized, that is that slightly different parameter values
(population size, migration rate, dispersal rate) may produce slightly different trees -
different distributions of the genealogical properties. Such parameters are generally
not known with precision, so identifying the parameters values that may have led to the observed
genetic data become the main point of coalescence-based inference.

This a feasible because the characteristics of gene trees generated by a model
grandly affect the genetic patterns of the sample when mutations are superimposed
on the genealogies.

![]({{site.url}}/pictures/decrypt/parameter_estimation.gif)

*Maximum Likelihood estimation of the mean parameter of a model. Modifying the parameter of a model modifies the distribution
of the data that can be generated under this model. In a coalescence setting, modifying
the growth rate of a spatially explicit demographic model modifies the genealogical properties
and the sample genetic diversity that depends on these genealogies.
Finding both the model and the parameter that allows to best match observed patterns is the purpose of inference.
The [likelihood function](https://en.wikipedia.org/wiki/Likelihood_function) is a way to describe the quality of the match. [Animation borrowed from towardsdatascience.com](https://towardsdatascience.com/maximum-likelihood-estimation-984af2dcfcac).*

> **Task**
 - What other inference methods do you know?
 - In these methods, how is represented the match quality to the observations?


# References

Irwin, K., Laurent, S., Matuszewski, S. et al. On the importance of skewed offspring distributions and background selection in virus population genetics. Heredity 117, 393–399 (2016). https://doi.org/10.1038/hdy.2016.58
