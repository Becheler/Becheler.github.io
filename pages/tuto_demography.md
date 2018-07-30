---
layout: quetzal
title: Quetzal Tutorials
tagline: the C++ Coalescence Template Library
description: Forward-in-time demographic simulations tutorial
use_math: true
---

# Demographic simulation hypothesis

There are two main ways to simulate the expansion of populations of individuals
in a discrete landscape:
- dispersing each individual separately according to a user-defined probability distribution.
- splitting each population across space according to user-defined migration probabilities.

These two strategies can seem quite similar in theory, but their computational border-effects
are quite distinct and are detailed below.

## Individual-based dispersal in small populations

For the biologist, the most intuitive simulation behavior would be that each individual
disperse independently. Accordingly, we defined a demographic expansion algorithm
where the location of each individual after the dispersal event
is sampled in a dispersal location kernel.

### Pros
This is a comfortable simulation model, as it guarantees without computational tricks
that the number of individual in a deme is always an integer: simulating the
coalescence process is then straightforward.

### Cons

This solution is **computationally costly** whenever the number of individuals
in the landscape is too high. Unfortunately, we typically have little control over this constraint, due to the
ABC random sampling of parameters value.

### Mathematical description
After the reproduction, the children dispersal is done by sampling their destination
in a multinomial law, that defines $ \Phi_{x,y}^t $, the number of individuals going from
$x$ to $y$ at time $t$:

$$
  (\Phi_{x,y}^{t})_{y \in X} \sim M(\tilde{N}_{x}^{t},(m_{xy})_y) ~.
$$

The term $ (m_{xy})_y $ denotes the parameters of the multinomial law
giving for an individual in $x$ its proability to go to $y$.
These probabilities are given by the dispersal law with parameter $\theta$:

$$
 \begin{array}{cclcl}
 m  & : &  X^2 & \mapsto & R_{+} \\
 &   &    (x,y)     & \mapsto & m^{\theta}(x,y)  ~. \\
 \end{array}
$$

 After migration, the number of individuals in deme $x$ is defined by
 the total number of individuals converging to $x$:

 $$
  N(x,t+1) = \displaystyle \sum_{i\in X} \Phi_{i,x}^{t}~.
 $$

### Step-by-step implementation

First create a new file ```demo.cpp``` to write the simulation code in.

#### Including the required features

First we need to include the files allowing to build a demographic expansion.
This can be for example the ```History``` class, that is part of the ```demography```
module. So first make sure to include the demography module:

```cpp
#include "quetzal/demography.h"
```

We will also need a couple of things:
- print objects in the terminal
- a random number generator for the simulation
- a simple, standard bernoulli random distribution to representation migration between two demes

To get these features we include some STL features:

```cpp
#include <iostream>
#include <random>
```

#### Expliciting the simulation model framework and hypothesis

A feature of Quetzal is that it makes no hypothesis about the space or the time representation.
It is quite important to allow users to consider any way to represent space and time
dimensions, using for example a geographic coordinates system.

Here we keep things simple so we consider the time to be represented by integer years,
and the space to be represented also by integers:
- the number 1 representing the first deme
- the number -1 representing the other deme.

We specify these choices by defining some **type aliases** to keep things clear and
to be able to later change more easily the types if needed:

```cpp
using coord_type = int;
using time_type = unsigned int;
```

We also want to use a standard **random number generator**, the mersenne twister engine:

```cpp
using generator_type = std::mt19937;
```

We choose the individual-base strategy. Again, a **type alias** is welcome here:
```cpp
using quetzal::demography::strategy::individual_based;
```
#### Demographic history initialization
We want to initialize the demographic history with some individuals in deme 1 in year 2018.
We use the ```History``` class, that is an implementation of a forward-in-time
demographic simulator defined in the ```demography``` module.

Using **template arguments**, we declare that this history has to be
recorded using the ```coord_type``` coordinate system and ```time_type``` temporal points.
We also need to specify that we need the special simulator version implemented with the ```individual_based``` strategy.

```cpp
quetzal::demography::History<coord_type, time_type, individual_based> history(1, 2018, 10);
```
#### Implementing a local growth process

Quetzal allow to represent the number of individuals in deme $x$ at time $t$ by
any function of space and time: constant functions, uniform, stochastic or deterministic
forms are all possible.

However, most of the time, we would like some kind
of temporal dependency. That is, we need to know the number of individuals at the previous
generation to be able to define the number of children.

We can retrieve this information using the following code line:

```cpp
auto N = std::cref(history.pop_sizes());
```
The use to ```std::cref``` is motivated by the fact we need a **copiable reference**
to the population size history. This little trick allows to capture the history
in a **lambda expression** encoding the growth process without having to copy the whole
historical database.

We can define the number of children as being deterministically twice the number of parents:

```cpp
auto growth = [N](auto& gen, coord_type x, time_type t){ return 2*N(x,t) ; };
```
This little **functor** is very cheap to copy and can be freely passed around the
simulation context.

We could as well have used the random generator argument to define it as a stochastic process modeled by
a Poisson distribution with mean parameter $\lambda = 2N(x,t)$:

```cpp
auto growth = [N](auto& gen, coord_type x, time_type t){
  std::poisson_distribution<unsigned int> dist(2*N(x,t));
  return dist(gen);
 };
```

#### Implementing a dispersal location kernel

The ```individual_based``` strategy requires a specific type of dispersal function.
Remember that for each individual, a post-dispersal location is sampled in a distribution.

Complex distance-based location dispersal distribution can be constructed from a geographic support
using Quetzal helper functions, but for now a very simple dispersal process will be sufficient to highlight
the simulator behavior.

Basically we need to construct a function that can be called with three arguments:
- the random number generator for the random part of the process
- a ```coord_type``` argument that gives the place where the individual is *before dispersal*
- a ```time_type``` argument giving the time at which the dispersal occurs.

The temporal argument is generally useless for pure distance-based dispersal that are constant in time.
However, this argument allows important extensions:
- if the temporal scale is large enough, the dispersal parameters can vary through time.
- if the landscape heterogeneity is assumed to impact dispersal, then one may have to account for temporal
variations of the landscape.

Here we define a very simple stochastic dispersal distribution, where the geographic
sampling space is only the two considered demes $\{-1 , 1\}$ and with a 50% chance
to disperse to the other deme:

```cpp
auto sample_location = [](auto& gen, coord_type x, time_type t){
  std::bernoulli_distribution d(0.5);
  if(d(gen)){ x = -x; }
  return x;
};
```

#### Expanding the history

We first define the number of non-overlapping generations to simulate, and we also initialize the
random number generator:

```cpp
unsigned int nb_generations = 3;
generator_type gen;
```

We can finally expand the history through space and time, and print out the flows historical
database for visual check:

```cpp
history.expand(nb_generations, growth, sample_location, gen);

std::cout << "Population flows from x to y at time t:\n\n"
          << history.flows()
          << std::endl;
```

### Complete script and compilation options

#### Compilation options

The complete `demo.cpp` script is given below.

It compiles with the following terminal command:
```
g++ -Wall -std=c++14 demo.cpp
```
- the option `-Wall` enables all warnings
- the option `-std=c++14` enables the C++14 standard compiler support

Then you can run the program with the following command:
```
./a.out
```

#### Complete script

```cpp
#include "quetzal/demography.h"
#include <iostream>
#include <random>

int main(){

  // Here we simulate a population expansion through a 2 demes landscape.

  // Use type aliasing for readability
  using coord_type = int;
  using time_type = unsigned int;
  using generator_type = std::mt19937;

  // choose the strategy to be used
  using quetzal::demography::strategy::individual_based;

  // Initialize the history with 10 individuals introduced in deme x=1 at time t=2018
  quetzal::demography::History<coord_type, time_type, individual_based> history(1, 2018, 10);

  // Get a reference on the population sizes database
  auto N = std::cref(history.pop_sizes());

  // Capture it with a lambda expression to build a growth function
  auto growth = [N](auto& gen, coord_type x, time_type t){ return 2*N(x,t) ; };

  // Number of non-overlapping generations for the demographic simulation
  unsigned int nb_generations = 3;

  // Random number generation
  generator_type gen;

  // Stochastic dispersal kernel, purposely very simple
  // The geographic sampling space is {-1 , 1}, there is 50% chance to migrate
  auto sample_location = [](auto& gen, coord_type x, time_type t){
    std::bernoulli_distribution d(0.5);
    if(d(gen)){ x = -x; }
    return x;
  };

  history.expand(nb_generations, growth, sample_location, gen);

  std::cout << "Population flows from x to y at time t:\n\n"
            << history.flows()
            << std::endl;
}
```

The output would be:

```
Population flows from x to y at time t:

time	from	to	flow
2020	1	-1	17
2020	1	1	25
2020	-1	-1	21
2018	1	1	12
2020	-1	1	17
2019	1	-1	12
2019	-1	-1	7
2018	1	-1	8
2019	-1	1	9
2019	1	1	12
```

## Mass-based dispersal for big populations
