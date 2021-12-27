---
layout: tutorial_post
title: A random walker in a canyon
tagline: the C++ Coalescence Template Library
description: Forward-in-time demographic simulations tutorial
use_math: true
img: schemes/decrypt_sampling_scheme.png
---

Imagine you're a phD student lost in the Kalahari desert with your trainee and one mission: studying a population of mosquitoes that thrive in two oasis in the middle of nowhere :dromedary_camel: :dromedary_camel: :dromedary_camel:

You have no mathematical skills, no internet, no phone, no advisor: just a computer and the Quetzal documentation. How brave you are!

In your infinite wisdom, you decide that a very first step in the right direction would be to *at least* come up with some simulation of the mosquitoes population. So you proceed to daub yourself with large amounts of insect repellent so you can give a closer look to these flying, biting buggers  :bee:

It seems that the two oasis are similar in size and resources, separated by some distance, but still close enough to enable mosquitoes to move from one to the other in what seems to be a quite random pattern. By using your trainee as a living bait, you succeeded to capture several fecundated females, that laid on average 100 eggs each before they died. When the larva hatch, the newborns automatically fly to one of the two oasis to look for mates. :palm_tree:

## Mathematical formalization of the biological problem

You have no idea what to do with this biological knowledge. You try to write some symbols on the sand, but they don't make any more sense to you than to the vultures circling in the sky. You feel a cold sweat running down your back as you're seized by the overwhelming sensation of a looming disaster: you hold your breath as if it could stop time and prevent your foreseeable academic failure
:cold_sweat:

Suddenly, you hear a voice coming from behind your shoulder.

> "Hey! Awww you're doing math? That's so cool! I majored in probability and statistics!"

You turn so fast that you trip in the sand and fall on your knees: your trainee is smiling at you, proudly wearing on their skin the bumpy, inflamed marks of their dedication to the cause. Your savior. Your hero.

### Defining the landscape

After few hours of philosophical debate on the nature of space and time, you two decide to simplify the landscape to a set $X$ of 2 demes (the two oasis) connected by *some degree* of migration.

You decide that:

- :palm_tree: the Eastern oasis will be encoded by $1$
- :palm_tree: the Western oasis will be encoded by $-1$.

As it's getting dark already, you go to bed feeling much more hopeful about a brighter future :crescent_moon:

### Reproduction

On the morning, you sip your coffee while exchanging about mating ceremonials in the insect realm.

Focusing the discussion on your biological system, you assume that the mosquitoes reproduction events are synchronized (no generation overlap), and that $\tilde{N}(x,t)$, the population size after reproduction in oasis $x$ at time $t$ is simply equal to the population size *before* reproduction times the fecundity *r*:

\\[
  \tilde{N}(x,t) = r.N(x,t)
\\]

### Migration

You also give some thoughts about migration patterns.

From what you remember from your textbooks, you have no reason to believe that mosquitoes disperse in flocks, what simplifies things quite a bit if you can consider each individual movement independently.

You begin to think of a demographic algorithm where the location of every individual after the dispersal event would be *somehow* sampled in a probability distribution.

> "You see what I mean?" you ask your new maths guru :persevere:
>
> "Yeah, but considering you have only 2 locations, I think you simply want to sample a binomial, right?"

You deflect the question by pretending you are in a dire need for coffee, conveniently hiding your ignorance by letting the mathematician do their mathematical things :coffee:

But when you cautiously come back, the sand is covered with mysterious notations. Without leaving you any time to escape, the trainee proceeds to explain the modelisation :expressionless:

After reproduction, the children dispersal is simulated by sampling their destination
in a binomial law, that defines $ \Phi_{x,y}^t $, the number of individuals going from
$x$ to $y$ at time $t$:

\\[
( \Phi_{x,y}^{t} )\_{y \in X} \sim B(~\tilde{N}(x,t),~p)
\\]

The term $ p $ is the parameter of the binomial distribution, giving for a mosquitoe in oasis $1$ its probability to travel to the other oasis $-1$.

After migration, the number of individuals in oasis $x$ is defined by  the total number of mosquitoes converging to $x$:

\\[
N(x,t+1) = \displaystyle \sum_{i\in X} \Phi_{i,x}^{t}~.
\\]

> "You spent the whole flight sleeping on this big manual, you should have at least some idea of how to simulate this demographic model using Quetzal, right?"
>
> "Eeeeeh ... Huho look at the time! Let's go get some coffee..." :trollface:

## Simulation using Quetzal-CoalTL

Now that we have the ideas a bit more clear about the demographic model and the underlying assumptions, we want to write some code to simulate the process. Don't forget that we are not interested *only* by the demographic process: *in fine*, the whole goal of these tutorials is to use it to condition a coalescence process and simulate some genetic data!

If you are a population geneticist, you are certainly thinking:

>"wait a minute, we don't need that, this is a standard model with well-known solu..."
>
> "... ta ta ta taaa! I see you coming! Don't take the fun out of this tutorial. We were doing sooo well without you, reinventing the wheel and stuff!

I agree. It's a dumb model :disappointed_relieved:
But baby steps, baby steps... :baby:

### The Quetzal demography module

You open the big bad book, and look at the [*demography* chapter]().

### Complete code solution

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

So now that we included the required pre-existing code, we can begin to write our own code
in the main function of the program:

```cpp
#include "quetzal/demography.h"
#include <iostream>
#include <random>

int main
{

  // we will write things here

  return 0;
}
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

#### Implementing a dispersal location kernel <a name="dispersal_sampler"></a>

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


## Mass-based dispersal for big populations <a name="mass_based"></a>

We can avoid the cost of having to disperse each individual of the landscape by
considering a model where population masses would be split through the landscape
according to migration probabilities: the model is deterministic
in the sense that no random number is generated.

### Pros

This algorithm is more efficient as the computation time is now only related to
the number of demes in the landscape. Consequently it allows to perform simulations
with high number of individuals in a very reasonable amount of time

### Cons

Defining a strategy that is more efficient for high populations levels
comes with the major drawback that it is unsuited whenever populations are too small:
> What if 10 individuals are split across 1000 demes ?

> What does 0.001 individual mean in terms of coalescence probability ?

It could seem easy to ensure it never happens. Unfortunately, population levels
are actually hard to control in an ABC simulation context where
parameters are randomly sampled, so we can hardly guarantee that this situation will
not arise.

We avoid the problem with a computational little trick: when summing the population
flows arriving to a same deme, the least integer greater or equal to the actual flow value
is used.

So when dispersing 2 individuals in a 4-demes landscape with equal migration
probabilities, the simulation will end up with $\lceil 2 \times 0.25 \rceil = 1$ individual in each deme...

That is, dispersing 2 individuals leads to having 4 individuals in the lanscape.

Obviously this behavior is not satisfying if the high-population hypothesis is violated,
but when the population size in each deme is of the order of the
number of demes, this little excess is expected to have little impact.

### Mathematical description

 The children dispersal is done by splitting the population masses according
 to their migration probabilities, defining
 $ \Phi_{x,y}^t $, the population flow going from $x$ to $y$ at time $t$:

 \\(
 (\Phi_{x,y}^{t})_{y\in  X} =  ( \lceil \tilde{N}_{x}^{t} \times m_{xy} \rceil )_{y\in  X} ~.
 \\)

 The term $ m_{xy} $ denotes the parameters of the transition kernel,
 giving for an individual in $x$ its probability to go to $y$.
 These probabilities are given by the dispersal law with parameter $\theta$:

 \\(
 \begin{array}{cclcl}
 m  & : &  X^2 & \mapsto & R_{+} \\
 &   &    (x,y)     & \mapsto & m^{\theta}(x,y)  ~. \\
 \end{array}
 \\)

 After migration, the population size in deme $x$ is defined by the sum of population flows converging to $x$:

 \\(
 N(x,t+1) = \displaystyle \sum_{i\in X} \Phi_{i,x}^{t}~.
 \\)

### Implementation

Most of the features are the same than for the [individual_based](#ind_based) strategy.

The only thing changing is the way to represent a dispersal kernel. For the individual-based
strategy, we needed to [sample a new location conditionally to the present location](#dispersal_sampler).

Now we just need a function that returns $m_{xy}$, the probability to move from
$x$ to $y$ at time $t$. Basically, we need a transition matrix, not a random sampler.

Note that we are not forced to use a matrix data structure: it is enough to implement
a **functor** returning the migration rates, that is to define the member function
`operator()(coord_type x, coord_type y, time_type t)`.

Another important constraint is that we need this transition matrix to give the set
 of inhabitable demes representing the landscape.

 ```cpp
 struct transition_matrix {
   using coord_type = int;
   using time_type = unsigned int;

   std::vector<coord_type> state_space(time_type t)
   {
     return {-1, 1};
   }
   // 1/2 probability to change of location
   double operator()(coord_type x, coord_type y, time_type t)
   {
     return 0.5;
   }
 };
 ```

Here we assume that the spatial representation
is constant through time so the temporal argument `time_type t` is not used in the
body of the `state_space` function.

It is however an important extension point. Indeed at large temporal
scales we expect the landscape to go through some form of modification, for example
contraction or expansion of the inhabitable areas due to sea-level rises  or glaciation.

In this case we would be interested to use this time argument in the function implementation
in order to implement this dynamic.

For the rest it is totally similar with the individual based strategy.

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

The complete
code is given below. We changed the type of the demes identifiers - that have now
names of cities, just to demonstrate that Quetzal functions are not linked to any
precise geographical coordinate system.


```cpp
#include "quetzal/demography.h"

#include <iostream>
#include <random>
#include <map>

struct transition_matrix {

	using coord_type = std::string;
	using time_type = unsigned int;

	std::vector<coord_type> state_space(time_type t)
	{
		return {"Paris", "Ann Arbor"};
	}

	double operator()(coord_type x, coord_type y, time_type t)
	{
		return 0.5; // 1/2 probability to change of location
	}

};

int main(){

	using coord_type = std::string;
	using time_type = unsigned int;
	using generator_type = std::mt19937;

	// Initialize history: 100 individuals introduced at x=1, t=2018
	using quetzal::demography::strategy::mass_based;
	quetzal::demography::History<coord_type, time_type, mass_based> history("Paris", 2018, 100);

	// Growth function
	auto N = std::cref(history.pop_sizes());
	auto growth = [N](auto& gen, coord_type x, time_type t){ return 2*N(x,t) ; };

	// Number of non-overlapping generations for the demographic simulation
	unsigned int nb_generations = 3;

	// Random number generation
	generator_type gen;

	transition_matrix M;

	history.expand(nb_generations, growth, M, gen);

	std::cout << "Population flows from x to y at time t:\n\n" << history.flows() << std::endl;

	return 0;
}
```

The expected output is:

```
Population flows from x to y at time t:

time	from	to	flow
2020	Ann Arbor	Ann Arbor	20
2020	Paris	Paris	20
2018	Paris	Ann Arbor	10
2020	Ann Arbor	Paris	20
2019	Ann Arbor	Ann Arbor	10
2020	Paris	Ann Arbor	20
2019	Paris	Paris	10
2018	Paris	Paris	10
2019	Paris	Ann Arbor	10
2019	Ann Arbor	Paris	10
```

# Conclusion

You now know how to implement your own little demographic simulator.

If you have very peculiar growth or dispersal model, this tutorial demonstrated that you can
inject user-defined implementations into Quetzal components.

However, you will surely not manually hard-code the migration rates between hundreds
of demes in a landscape.

You may find in Quetzal a way to automate the process of [constructing spatially explicit,
distance-based dispersal kernels]({{ site.url }}/pages/tuto_dispersal).

But before to compute probabilities across space, you first need to know more
about [how to represent a spatially explicit landscape]({{ site.url }}/pages/tuto_geography)!