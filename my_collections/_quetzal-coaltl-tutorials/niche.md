---
layout: tutorial_post
img: schemes/decrypt_sampling_scheme.png
title: Linking environments to species ecology
tagline: the C++ Coalescence Template Library
description: Defining niche functions
use_math: true
---

By *niche functions*, we mean here any quantity of an ecological model that is linked to environmental
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

## An example: the logistic growth

For example, let's consider the typical logistic function that is used in the literature
to represent the local growth process, and let's couple the growth rate and the carrying
capacity to the environmental heterogeneity.

The following picture illustrate a one-deme growing population size following a logistic growth,
with carrying capacity $K=500$, for different values of $r$:

![logistic growth]({{site.url}}/pictures/logistic.png)

### Mathematical description

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

We will show how to implement this model with toy functions.

### Step-by-step implementation

#### About the need to build callable expressions

So you learned in the [geography tutorial](tuto_geography) how to retrieve the environmental functions:

```cpp
auto f = env["rain"];
auto g = env["temperature"];
```
>**Note:** Remember that you can call `f` and `g` with space and time arguments
by writing `f(x,t)` and `g(x,t)`.

As the demographic expansion loop over space and time lays in the core of
complex simulation objects, you do not want to pass each of these values one-by-one
across the multiple layers of these objects: that would be very inefficient.

Instead, it is better to give to the simulator the expression that it will call.

You just need to code a function simulating the number of children in deme $x$
at time $t$. Any expression would work: the core algorithm will deal with it if it
has the right signature.

In the [demography tutorial](tuto_demography#implementing-a-local-growth-process),
you already learned how to build a very simple version of such expressions: it
was simply twice the number of parents. Let's remember this simple example code:

```cpp
// access to the demographic history database
auto N = std::cref(history.pop_sizes());
// capture N in a lambda expression
auto growth = [N](auto& gen, coord_type x, time_type t){ return 2*N(x,t) ; };
```
Here we will just learn how to define more complicated expressions that are
mathematical compositions of the environmental functions.

### Composing functions of space and time

What you want to do is to build an expression that is the result of composing other
functions, and you expect this to be easy. You would actually expect to be able to write
something like:

```cpp
auto f = env["rain"];
auto g = env["temperature"];
auto h = f + g; // compilation error, undefined operator +
```
This code would not compile, as C++ does not natively know what adding $f$ and $g$ mean.

To enable the composition, you need to use the  `expressive` module.
This module is actually a library written by [Ambre Marques](https://github.com/ambre-m),
that allows to compose expressions at compile-time:

```cpp
#include "my_path/quetzal/expressive.h"

// ... some code to build the environment object env

auto f = env["rain"];
auto g = env["temperature"];

using quetzal::expressive::use;
auto h = use(f) + use(g); // expressive automatically define the operator +
```

In this code, `h` is a new object. Its type is automatically built by `expressive`
and is unknown by the user: that is actually a good thing, as it can be very complicated.
More importantly, as the `h` object is cheap to copy, it can be passed around the
simulation context to the appropriate function where it will be called with spatio-temporal
coordinates:

```cpp
// file main.cpp
auto h = use(f) + use(g);

coord_type x;
time_type t;
std::cout << h(x,t) << std::endl;
```

### Composing constant functions

In the same way can not expect the following line to work:
```cpp
auto e = h - 4; // // compilation error, undefined operator -
```
It is expected, as C++ does not natively know how to add an integer to a function.
So first you have to transform the number 4 to a constant function of space and time:

```cpp
using quetzal::expressive::literal_factory;
// a small object able to produce callables:
literal_factory<coord_type, time_type> lit;
auto e = h - lit(4); // now it works
```

See ? You can actually freely compose any user-defined function.

## Coupling environment, logistic growth model and stochastic sampling:

Here are some code lines implementing a possible variant of the previously described
mathematical model where the number of children is a function of the number of
parents, of a constant growth rate, and where the carrying capacity is the mean
of the environmental variables:

```cpp
// ... build the environment before this

using quetzal::expressive::literal_factory;
using quetzal::expressive::use;
literal_factory<coord_type, time_type> lit;

// constant growth rate
auto r = lit(10);

// carrying capacity averging over rain and temperature
auto K =  ( use(f) + use(g) ) / lit(2) ;

// retrieving the population size history
auto N_cref = std::cref(history.pop_sizes());

// Enabling its use with expressive:
auto N_expr = use([N_cref](coord_type x, time_type t){return N_cref(x,t);});

// Making the logistic growth expression:
auto g = N_expr*(lit(1)+r)/ (lit(1)+((r * N_expr)/K));

// capturing g to build a sampling distribution
auto sim_N_tilde = [g](generator_type& gen, coord_type x, time_type t){
  std::poisson_distribution<history_type::N_type::value_type> poisson(g(x,t));
  return poisson(gen);
};

```
 Then you can pass the `sim_N_tilde` expression to a demographic simulator.
 Remarkably, even if you change some lines you will always be able to pass
 this expression to the demographic simulator
 as long as you don't modify its signature `(generator_type& gen, coord_type x, time_type t)`.


# Conclusion

Of course this niche model is not relevant: it's a toy model. The main point is that it
is very easy for the user to modify it.

> But what if $r$ is unknown and you want to estimate it ?

The ABC tutorial will give you insights on how manipulating the parameters of the
niche functions in an ABC framework.
