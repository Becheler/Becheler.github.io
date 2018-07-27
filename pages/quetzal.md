---
layout: quetzal
title: Quetzal
tagline: the C++ Coalescence Template Library
description: home
---

# What is Quetzal?

Quetzal is a collection of C++ code snippets, that can be picked and combined to
build complex, spatially explicit population genetics simulators and inference frameworks.

![Quetzal scheme]( {{site.url}}/draw/quetzal_scheme.png)

# Why should I care ?

## You are a researcher exploring a new model

The principal activity of a researcher is to explore new questions. Using computational methods
to explore new territories is a powerful technique, but it requires a solid equipment
that can adapt to change.

If the software breaks at each minor theoretical change, your exploration will be
painful, or even worse: impossible!

The task of a [research software engineer](https://rse.ac.uk/about/) is to enable
the scientific curiosity by building powerful equipments, ideally both efficient and flexible.

Using Quetzal allows the researcher to **widen the limits** of the traditional spatially explicit
and coalescence-based models.

## You are a research software engineer

Is your task to implement a new coalescence-based simulator following a model specified by a researcher ?

Well, here are some bad news:
 - Reusing or adapting existing code bases is hardly feasible.
 - We never have time to re-code everything from scratch.
 - Supposing you succeed to write the correct program
in a reasonable amount of time (which is not yet certain) **sooner or later the model will change**,
and you will have to start all over again.

> Walking on water and developing software from a specification are easy if both are frozen.
> -Edward Berard

We all know that there is no such thing as frozen specification. Building a
system in a changing environment is challenging, and you need the right tools.

But here are the good news:

Quetzal is an open-source set of C++ abstractions (template classes, functions, algorithms, concepts)
that provides a nice starter-pack to write your own simulation program.

You will probably not find everything that you need.

But you will surely spare time by **not re-inventing the wheel**.

# Why a library and not a program ?

In biology we love programs.

We love them because they are nice black-boxes eating data and digesting them in
a process we can adjust using a neat interface (configuration files, GUI...).

All the magic happens without having to worry about programming languages, design or architecture.

![Magic behind]({{site.url}}/pictures/user-interface.gif)

So naturally we tend to think that programs are the first and final answer
for any computational problem. So we end up with a variety of programs fulfilling a
variety of behaviors. When one program is not enough for a given purpose, we
concatenate it to another, using scripts to pipe outputs to inputs.
However, this is not always efficient, and there are important limits to this tradition.

First of all: what if the options of the first program do not meet our need ?

Quetzal existence stems from the fact **it was impossible to customize the behavior
of a pre-existing program in the desired way using the available options**.

So we had to re-implement **everything**.

Programs are not the right level of granularity to reuse the work of other coders.

> The key to fast development, correctness, efficiency, and maintainability is
to use a suitable level of abstraction supported by good libraries.
> -Stroustrup

When your scientific question leads to change a minor detail in a simulation model,
you do not want to have to recode everything, right ? So it
means that this very detail should be the right unit of code. In this way you can just
replace a piece of code by another in a very easy way.

This is the meaning of components libraries.

And you do not want to pay computation time for this flexibility, right ? So we
use the C++ template mechanism to build these components. In this way they can be
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

# Going further is part of the fun

Actually it was the main focus of Quetzal design: answering some questions by enabling new ones.

- Do you want to change the dispersal model ?
- Do you want to simulate explicit allelic states ?
- Do you want to change the demographic growth ?
- Do you want to incorporate landscape heterogeneity in the model ?

This is totally expected and doable: code only your customized components respecting some basic
constraints, and inject them in your main function.

Quetzal code will adapt to your components: **no need to recode everything !**
