---
layout: quetzal
title: Quetzal
tagline: the C++ Coalescence Template Library
description: home
---

# What is Quetzal?

Quetzal is a collection of C++ code snippets, that can be picked and combined to
build complex, spatially explicit population genetics simulators and inference frameworks.

It has been designed as a **toolbox** allowing a programmer to switch between several
modeling frameworks, and to **rapidly test different models**.

![Quetzal scheme]( {{site.url}}/draw/quetzal_scheme.png)

# Quick demonstration

### Step 1 - Design your own model

The user can freely specify the demographic model that is used to simulate a
demographic history in a discrete geographic space.

For example, to simulate a fast demographic expansion in Western Europe, we will use
here:
* a nearest-neighbor migration process
* a carrying capacity set as a function of the local rainfall values
* a growth rate set to a constant

Quetzal makes it easy to set and modify the details of this model and to add
or remove some stochasticity.

### Step 2 - Simulate a time-forward demographic history

All the demographic events are recorded by the simulation, and
the population sizes across the landscape can be simulated and exported in
geospatial files for visualization:

![Example of demographic expansion]( {{site.url}}/demo/model1/history.gif)

### Step 3 - Simulate the gene genalogies backward in time

#### Sampling scheme

For data analysis, you would probably consider a real genetic dataset.
For methodological exploration purpose you would
want to specify a controlled sampling design: in this example the sampling of genetic material
is simulated around two regions (Spain and Sicilia) only if the simulated local
population size is high enough.

![Sampling schemes]( {{site.url}}/demo/model1/sampling.png)

#### Coalescence process

Starting from this sampling scheme, Quetzal track the genes genealogies
back in the demographic history, allowing to export relevant information to other frameworks.

![Coalescent tree]( {{site.url}}/draw/demo/tree.png)

Simulating these genealogies allows to efficiently simulate genetic diversity patterns,
possibly using Quetzal or exporting the trees in Newick format to others simulators.


# Why a library and not a program ?

## Why should I care ?

### You are a researcher exploring a new model

The principal activity of a researcher is to explore new questions. Using simulations
to explore new complex models is a powerful technique, but it requires a solid
code base that can adapt to theoretical changes.

If the software breaks at each minor change, the exploration would be
painful, almost impossible!

Quetzal allows the researcher to **widen the limits** of the traditional spatially explicit
and coalescence-based simulators by allowing the customization of key aspects of
the problem: populations reaction to landscape heterogeneity and genes genealogies
simulations details.

As nothing is never free is this wild world, this flexibility comes at a cost:
using Quetzal requires technical knowledge in C++, so perhaps you would need a
Research Software Engineer to code your model.

### You are a Research Software Engineer (RSE)

[You do not know if you are or not a RSE?](https://rse.ac.uk/who/)

Do you have to implement or extend a coalescence-based simulator specified by a researcher ?

Well, here are some bad news:
 - Reusing or adapting existing code bases for structured coalescence is hardly feasible.
 - We never have time to re-code everything from scratch.
 - Supposing you succeed to write the correct program
in a reasonable amount of time (which is not yet certain) **sooner or later the model will change**,
and you will have to start all over again.

> Walking on water and developing software from a specification are easy if both are frozen.
> -Edward Berard

We all know that there is no such thing as frozen [specification](https://en.wikipedia.org/wiki/Software_requirements_specification). Building a
system in a changing environment is challenging, and you need the right tools.

But here are the **good news**:

As an open-source set of C++ abstractions (template classes, functions, algorithms, concepts)
Quetzal provides a nice starter-pack to write your own simulation program.

You will probably not find everything that you need.

But you will surely spare time by **not re-inventing the wheel**.

## Programs are not always the right level of configurability

Programs are super handy, because they act as nice black-boxes eating data and
digesting them in a process we can adjust using a neat interface (configuration files,
Graphical User Interface...). Thanks to programs, we biologists do not need to
worry about programming languages, design or architecture.

But what if the options of the program do not meet our need ?

In that case, we have to modify the code, to *extend it*, so we finally have to
worry about the programming language.

Modifications should be easy so we finally have to worry about design and architecture.

Indeed, Quetzal existence stems from the fact it was impossible to customize the behavior
of a pre-existing program in the desired way using the available options: we had
to re-implement **everything**. Programs are not the right level of
granularity when it comes to reusing the work of other coders.

> The key to fast development, correctness, efficiency, and maintainability is
to use a suitable level of abstraction supported by good libraries.
> -Stroustrup

But programs are still very usefull and user-friendly, so we are currently using Quetzal
to develop various programs!

## Small components libraries allow to tailor the code to your needs

When a scientific question leads to change a minor detail in the simulation model,
we never want to have to recode everything. So it means that this very level of
detail should be the right unit of code. In this way it is possible to only replace
a piece of code by another in a very easy way.

This is the meaning of components libraries.

And as we never want to pay computation time for flexibility, the C++ template
mechanism is used in Quetzal to build these components. In this way they can be
reused, adapted and extended to other contexts with maximal efficiency.

This is the meaning of a C++ template library: flexible, efficient, extensible.

# It's easier than you think

We designed Quetzal so the code can be very expressive and compact.

For example, here is a code extract of a documentation script. We use just some
of the Quetzal capabilities to simulate a demography in an arbitrary demic structure.

The keypoint is that even if the simulator behavior is complex, we have total control
on many implementation details and the code is still
compact, easy to read and fast to execute:

```cpp

// Total control on the data types and the simulation engine
using coord_type = std::string;
using time_type = unsigned int;
using quetzal::demography::strategy::individual_based;
using quetzal::simulators::SpatiallyExplicitCoalescenceSimulator;

// Demographic simulation setting
coord_type x_0 = "Paris";
time_type t_0 = 1912;
mass_based::value_type N_0 = 1000;

using simulator_type =
  SpatiallyExplicitCoalescenceSimulator<coord_type, time_type, individual_based>;

simulator_type simulator(x_0, t_0, N_0);

time_type sampling_time = 2018;

// Total liberty in the demographic growth model
auto N = simulator.pop_size_history();
unsigned int K = 20;
auto growth = [K, N](auto& gen, coord_type x, time_type t){
  return std::min(100*N(x,t), K);
};

// True but not shown: total liberty in the dispersal model,
Dispersal_sampler D;

// Chose your Random number generator
using generator_type = std::mt19937;
generator_type gen;

simulator.expand_demography(sampling_time, growth, D, gen);

// User defined coalescence data structures
using tree_type = std::string;
using forest_type = quetzal::coalescence::Forest<coord_type, tree_type>;
forest_type forest;

// Insert some nodes at some locations:
forest.insert("Paris", std::vector<tree_type>{"a", "b", "c"});
forest.insert("Ann Arbor", std::vector<tree_type>{"d", "e", "f"});

// Need to generate some Newick formula ? Just code it...
auto branching_operator = []( auto parent , auto child ){
  if ( parent.size () == 0)
  return "(" + child ;
  else
  return parent + "," + child + ")" ;
};

// ... and inject it!
auto new_forest = simulator.coalesce_along_history(forest, branching_operator, gen);

for(auto const& it : new_forest ){
  std::cout << it.first << "\t" << it.second << std::endl;
}
```

And that's it !

Compile, run, and get as an output the ancestral location of the tree and
the topology:

```
Ann Arbor (((((a,d),e),b),f),c)
```

# About

**Maintainer:** [Arnaud Becheler](https://becheler.github.io/)

**How to cite:** [see the founder article](https://www.biorxiv.org/content/early/2017/11/06/214767)

**Community:** IRC channel \#quetzal on [Freenode](https://webchat.freenode.net/)

**Supported platform:** Linux

**Contribute:** Check [our Github repository](https://github.com/Becheler/quetzal) and use the [Pull Request system](https://help.github.com/articles/creating-a-pull-request/)
<P><B>Clone:</B><PRE CLASS="fragment">git clone %https://github.com/Becheler/quetzal.git</PRE></P>
