---
layout: tutorial_post
title: Migration between two demes
tagline: the C++ Coalescence Template Library
description: Forward-in-time demographic simulations tutorial
use_math: true
img: doodles/tutorials/mosquitoland.png
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

You open the big bad book, and look at the [*demography* chapter](https://becheler.github.io/quetzal-CoalTL/api/namespacequetzal_1_1demography.html). This page refers to everything (classes, functions, even other namespaces) that lives in the `quetzal::demography` namespace.

Since the documentation is mostly targeted at the developers, there are plenty of
details, and most of them are not very useful to you: you just want to simulate a demographic
history. But it's still worth to have a look at the general content of the `demography` module. There are 3 principal sections:

- **Namespaces** lists a bunch of namespaces. It's like opening a drawer
  with more drawers inside!

  - :small_airplane: In the `dispersal_kernel` drawer,
  you find a bunch of standard dispersal probability distributions

  - :computer: In the `demographic_policy` drawer, I placed the policy classes that control the dispersal details of the demographic algorithm (that is, what *moving stuff across demes* concretely means for the computer)

  - :floppy_disk: In the `memory_policy` drawer, I threw the policy classes that control what the computer is supposed to do with all these demographic data: keep them on RAM (hoping
    they are not too heavy) or save them on disk?

- **Classes** lists all the data structures that exists in the demographic modules.
  They mostly belong to 3 groups:

  - `Flow` to represent $\Phi(x,y,t)$: store, access and control demographic flows between discrete demes.

  - `PopulationSize` to represent $N(x,t)$: store, access and control population sizes.

  - `History` classes are your main interest: these classes harmonize the simulation by hiding the   access to `Flows` and `PopulationSize` objects. All `History` classes derive from a common `BaseHistory` (to reuse shared functionalities), but they can be specialized to implement a particular demographic algorithm (for example using a `demographic_policy`).

  - **Functions**: just some free functions to help around!

You have everything you need to begin coding: you prepare two liters of very dark coffee,
sit under a palm tree and begin to type in your IDE.

### Several hours later: complete code solution

:v: Victooooire!

It's almost night but you did it!

Your first functional Quetzal code! The first EGG in a long line! :egg:

#### Your beautiful main.cpp file

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp) -->
<!-- The below code snippet is automatically added from https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp -->
```cpp
// file main.cpp
#include "quetzal/demography.h"
#include <iostream>
#include <random>
// Here we simulate a population expansion through a 2 demes landscape.
int main(){
  // Use type aliasing for readability
  using coord_type = int;
  using time_type = unsigned int;
  using generator_type = std::mt19937;
  // choose the strategy to be used
  using quetzal::demography::demographic_policy::individual_based;
  using quetzal::demography::memory_policy::on_RAM;
  // Random number generator
  generator_type gen;
  // Number of non-overlapping generations for the demographic simulation
  int nb_generations = 3;
  // Coordinate of the origin of introduction
  coord_type x0 = 1;
  // Number of individuals introduced
  int N0 = 10;
  // Initialize the history:
  quetzal::demography::History<coord_type, individual_based, on_RAM> history(x0, N0, nb_generations);
  // Get a light callable object that behaves as a function of space and time
  auto N = history.get_functor_N();
  // Constant growth rate
  int r = 100;
  // Capture it with a lambda expression to build a growth function
  auto growth = [N,r](auto& gen, coord_type x, time_type t){ return r*N(x,t) ; };
  // Stochastic dispersal lambda function, purposely very simple
  auto sample_location = [](auto& gen, coord_type x){
    // 50% chance to move to the other deme
    std::bernoulli_distribution d(0.5);
    // The geographic sampling space is {-1 , 1}
    if(d(gen)){ x = -x; }
    return x;
  };
  // run the simulation
  history.simulate_forward(growth, sample_location, gen);
  // Output
  time_type t = nb_generations -1;
  for(auto x : history.distribution_area(t))
  {
    std::cout << "N(" << x << "," << nb_generations -1 << ") = " << N(x,t) << std::endl;
  }
} // end main
```
<!-- MARKDOWN-AUTO-DOCS:END -->

#### Compilation tiiime!

With utter delight and excitement, you enter the quetzal-NEST container (see previous tutorial).
Quetzal-NEST comes with pre-installed `vim` editor, that you can use to create text files.
- `cd home`
- `vim main.cpp`
- copy and paste the code, then save and exit vim
- compile with `g++ -Wall -std=c++17 main.cpp -o two_demes.exe`

> Compiler options:
- the option `-Wall` enables all warnings
- the option `-std=c++17` enables the C++17 standard compiler support
- the option `-o` renames the output

A fast `ls` should show that a new file has been created: `two_demes.exe` !

>  :boom: Any issue? Maybe this tutorial is outdated! Outrageous! Leave a comment so I can fix that :point_down:

#### Run tiiime!

Then you proceed to run the program with the following command:
```
./two_demes.exe
```
The output is (hopefully):

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

Glorious! Your first demographic simulation! You already want to turn the pages of the
documentation to interface it with a coalescence simulation!

But not so fast! What happens in this program?

## Step-by-step implementation

First create a new file ```main.cpp``` to write the simulation code in.

### Includes to import the code we need

First we need to include the files of code that allow to build a demographic
process: you do so by including the quetzal demography module with a ```include``` directive.

Second we want to use some tools present in the standard C++ toolbox:
- some utilities to print objects in the terminal we find in ```iostream```
- a random number generator for the simulation we find in ```random```
- a simple, standard bernoulli random distribution to representation migration between two demes we also find in ```random```

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp&lines=1-4) -->
<!-- The below code snippet is automatically added from https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp -->
```cpp
// file main.cpp
#include "quetzal/demography.h"
#include <iostream>
#include <random>
```
<!-- MARKDOWN-AUTO-DOCS:END -->

### Enter the main function

In C++, everything happens here:

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp&lines=5-6) -->
<!-- The below code snippet is automatically added from https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp -->
```cpp
// Here we simulate a population expansion through a 2 demes landscape.
int main(){
```
<!-- MARKDOWN-AUTO-DOCS:END -->

### Type aliasing to explicit the simulation model framework and hypothesis

A feature of Quetzal-CoalTL is that most of the modules make very little assumptions around the geographic space representation.

This has sometimes some conceptual cost about the nature of space and time :dizzy_face:, but it allows users to consider quite arbitrary ways to represent space and time dimensions, while still being able to adapt most of the library modules.

> In other words, that would need some testing but I'm pretty sure you can adapt the library to a range of geographic supports including
- few points on a plane :hole: :hole: :hole:
- a large grid :world_map:
- 3D surfaces :mountain:
- an orange :globe_with_meridians:
- or a doughnut :doughnut:

In the present case we only have two oasis (or populations, or demes). We don't not need a
complex spatial grid or a cubersome coordinate system. We can keep things very
simple by considering the time to be represented by integer years,
and the space to be represented also by integers:
- the number 1 representing the first deme
- the number -1 representing the other deme.

> We could absolutely chose to represent demes by two string "A" and "B", the code
would just be one or two lines longer.

We specify these choices by defining some **type aliases** to keep things clear and
to be able to later change more easily the types if needed: the demographic module will adapt!
We also want to use a standard **random number generator**, the mersenne twister engine.

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp&lines=7-10) -->
<!-- The below code snippet is automatically added from https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp -->
```cpp
  // Use type aliasing for readability
  using coord_type = int;
  using time_type = unsigned int;
  using generator_type = std::mt19937;
```
<!-- MARKDOWN-AUTO-DOCS:END -->

You can think of so many simulation algorithms for populations expansions!
In this very case, we will keep:
- the growth rate low
- the number of founders small
- the number of generations short

Because we don't have many individuals to handle, we choose the ```individual-based``` demographic strategy (or policy, in C++ language), that moves individuals independently.

> :bulb: As opposed to the ```mass-based``` demographic policy, that considers populations large enough to be infinitely splittable :scissors:

And because everything will obviously fit on the RAM and we won't need to record
the history on disk, we also explicit that by specifying the ```on_RAM``` memory
management policy! Again, a **type alias** is welcome here to shorten these statement further in the code:

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp&lines=11-13) -->
<!-- The below code snippet is automatically added from https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp -->
```cpp
  // choose the strategy to be used
  using quetzal::demography::demographic_policy::individual_based;
  using quetzal::demography::memory_policy::on_RAM;
```
<!-- MARKDOWN-AUTO-DOCS:END -->

> :crystal_ball: One day maybe, you will simulate histories so long that RAM will be you main bottleneck.
That day, think about the alternative strategy  ```on_disk``` :floppy_disk:

### Demographic history initialization

We want to initialize the demographic history with some individuals in deme 1. We use the ```History``` class, that is an implementation of a forward-in-time
demographic simulator defined in the ```demography``` module.

> :books: if you need to have a look at the class documentation, [it's here!](https://becheler.github.io/quetzal-CoalTL/api/classquetzal_1_1demography_1_1History_3_01Space_00_01demographic__policy_1_1individual__based_00_01Memory_01_4.html) Take a deeep breath :scream_cat:

Using **template arguments**, we declare that this history has to be recorded using our little *"coordinate system"* ```coord_type```  and ```time_type``` temporal points. We also specialize the ```History``` class by specifying that we need the special demographic algorithm ```individual_based```:

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp&lines=14-23) -->
<!-- The below code snippet is automatically added from https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp -->
```cpp
  // Random number generator
  generator_type gen;
  // Number of non-overlapping generations for the demographic simulation
  int nb_generations = 3;
  // Coordinate of the origin of introduction
  coord_type x0 = 1;
  // Number of individuals introduced
  int N0 = 10;
  // Initialize the history:
  quetzal::demography::History<coord_type, individual_based, on_RAM> history(x0, N0, nb_generations);
```
<!-- MARKDOWN-AUTO-DOCS:END -->

### Implementing a local growth process

Now that we are ready to record the demographic history, we would like
to define the population size with some kind of temporal dependency.
That is, we need to know the number of individuals in the previous
generation to be able to define the number of children in the new generation.

Well, we can simply ask the `History` to provide us with a little accessor on this information:

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp&lines=24-25) -->
<!-- The below code snippet is automatically added from https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp -->
```cpp
  // Get a light callable object that behaves as a function of space and time
  auto N = history.get_functor_N();
```
<!-- MARKDOWN-AUTO-DOCS:END -->

> :wrench: This gives you a **copiable reference** to the population size history. This little trick allows to capture the history in a **lambda expression** encoding the growth process without having to copy around the whole historical database - what would be quite inefficient!

So now, we can define the number of children:

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp&lines=26-29) -->
<!-- The below code snippet is automatically added from https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp -->
```cpp
  // Constant growth rate
  int r = 100;
  // Capture it with a lambda expression to build a growth function
  auto growth = [N,r](auto& gen, coord_type x, time_type t){ return r*N(x,t) ; };
```
<!-- MARKDOWN-AUTO-DOCS:END -->

> :wrench: This little **functor** is very cheap to copy and can be freely passed around the
simulation context.

> :bulb: You could chose to represent the number of individuals in deme $x$ at time $t$ by any function of space and time: constant functions, uniform, stochastic or deterministic forms are all possible. We could have used the random generator argument to define a stochastic process modeled by a Poisson distribution with mean parameter $\lambda = 2N(x,t)$.

### Implementing a dispersal location kernel <a name="dispersal_sampler"></a>

The ```individual_based``` strategy requires a specific type of dispersal function.
Remember that for each individual, a post-dispersal location must be sampled in a distribution.

> :wrench: Complex distance-based location dispersal distribution can be constructed from a geographic support
using Quetzal helper functions, but for now a very simple dispersal process will be sufficient to highlight
the simulator behavior.

Basically we need to construct a function that can be called with three arguments:
- a random number generator for some entropy
- ```coord_type``` argument that gives the place where the individual is *before dispersal*
- a ```time_type``` argument giving the time at which the dispersal occurs.

> :bulb: The time parameter is generally useless for pure distance-based dispersal that are constant in time.
However, this argument allows important extensions:
- if the temporal scale is large enough, the dispersal parameters can vary through time.
- if the landscape heterogeneity is assumed to impact dispersal (e.g., moving glacier margins ), then one may have to account for temporal variations in the landscape.

Here we define a very simple stochastic dispersal distribution, where the geographic
sampling space is only the two considered demes $\{-1 , 1\}$ and with a 50% chance
to move to the other deme:

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp&lines=30-37) -->
<!-- The below code snippet is automatically added from https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp -->
```cpp
  // Stochastic dispersal lambda function, purposely very simple
  auto sample_location = [](auto& gen, coord_type x){
    // 50% chance to move to the other deme
    std::bernoulli_distribution d(0.5);
    // The geographic sampling space is {-1 , 1}
    if(d(gen)){ x = -x; }
    return x;
  };
```
<!-- MARKDOWN-AUTO-DOCS:END -->

### Forwaaaard!

We can finally expand the history through space and time, print out the flows historical
database for visual check, and close the `main` function:

<!-- MARKDOWN-AUTO-DOCS:START (CODE:src=https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp&lines=38-46) -->
<!-- The below code snippet is automatically added from https://raw.githubusercontent.com/Becheler/quetzal-CoalTL/master/test/tutorials_test/tuto_1.cpp -->
```cpp
  // run the simulation
  history.simulate_forward(growth, sample_location, gen);
  // Output
  time_type t = nb_generations -1;
  for(auto x : history.distribution_area(t))
  {
    std::cout << "N(" << x << "," << nb_generations -1 << ") = " << N(x,t) << std::endl;
  }
} // end main
```
<!-- MARKDOWN-AUTO-DOCS:END -->

# Conclusion

You now know how to implement your own little demographic simulator.

If you have very peculiar growth or dispersal model, this tutorial demonstrated that you can
inject user-defined implementations into Quetzal components.

However, you will surely not manually hard-code the migration rates between hundreds
of demes in a landscape.

You will find in Quetzal a way to automate the process of constructing spatially explicit,
distance-based dispersal kernels.

But before to compute probabilities across space, you first need to know more
about how to represent a spatially explicit heterogeneous landscape!
