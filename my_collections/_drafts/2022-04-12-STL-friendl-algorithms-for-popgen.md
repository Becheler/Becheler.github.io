---
layout: post
title: How to write STL-friendly algorithms for population genetics
date: 2022-04-12 17:30
description: Approaching population genetics with a modern C++ design
img: doodles/i-aint-much.png # Add image post (optional)
fig-caption: It ain't much, but it's honest work  # Add figcaption (optional)
tags: [ecology, evolution, biogeography, coalescence, quetzal, C++]
sticky: false
use_math: true
---

When I have a new feature to implement, I look online to see if some code already exists
so I don't reinvent the wheel. However, my ability to find and reuse such feature
depends heavily on *how* it was initially coded. What I'm looking for is a carefully crafted, self-contained algorithm (or a class) that embeds its essential responsibilities but abstracts all non-essential aspects of the problem. If you want more details about the why, check [my article on the Single Resonsability Principle]({%post_url 2021-08-06-make-code-surgery-easy-with-SRP%}).

In a few words, I'm looking for a code with a **satisfying level of abstraction** that allows me to simply copy-paste the code and inject my own context-specific details into it without modification.

The [C++ Standard Template Library](https://en.cppreference.com/w/cpp) is a brilliant example of such components: whatever I'm doing when I'm using STL containers like a `std::vector` or
a `std::map` to store my objects or a STL algorithm like `std::accumulate` to sum the element
of an iterable, I never, *never*, **never** had to modify the STL source code. Absolutely reusable containers, algorithms, iterators and functors: this is absolute genius. That's why the STL is now kinda synonym with modern C++ (that is post-C++11): why would you code without this incredible resource? It's light, efficient, flexible, extensible, reusable... I'm looking for **this** kind of standard population genetics algorithms. **The gold standard of research software engineering.**

Unfortunately, in our academic world it happens that *re-usability* of code fragments is not the priority: mere usability in a core
project and downstream publications have much more weight (understandably!) than abstract
code components with high degree a reusability. However, I advocate (like many others) that an invisible cost exists, hidden in all the time and money spent by researchers-programmers who tried to locate, understand, isolate, reproduce an sometimes recreate such code fragments, compounded over time.

In my case, I spent a long time trying to find (and sometimes create) **C++ standard implementations** of some of the most popular algorithms in population genetics, like the basic [discrete-time coalescent without recombination](https://github.com/Becheler/quetzal-CoaTL/blob/master/include/quetzal/coalescence/algorithm/merge.h). Well, they exist in *some form*, diluted in the source code of existing projects like ms or msprime, but they were never abstracted into their essential components and concepts. Put simply, they were not reusable.

Today I'm looking towards another well-known algorithm: the Hudson's algorithm for simulating a coalescent with recombination as
formulated in the [Supplementary Material S1](https://journals.plos.org/ploscompbiol/article/file?id=10.1371/journal.pcbi.1004842&type=printable#%FE%FF%00R%00p%00c%00b%00i%00.%001%000%000%004%008%004%002%00.%00s%000%000%001) of  [Kelleher et al. (2016)](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004842).

Why this algorithm in particular? Because of a quite selfish reason: it happens it's the next step in my research project :see_no_evil: :angel:

But I think it is a really nice idea to both advance my research, and the field, and show you how I would approach STL-like algorithms design in modern C++.

-------------------------------

## The requirements

### The pseudocode

The Hudson algorithm is actually composed of three different algorithms:

- **Algorithm H**, Hudson algorithm: Simulate the coalescent with recombination for a sample of n individuals on a sequence of m sites with recombination at rate r per generation between adjacent sites.
- **Algorithm R**, Recombination event: Choose a link uniformly and break it, resulting in one extra individual in the set of extant ancestors.
- **Algorithm C**, Common Ancestor event: Choose two ancestors uniformly and merge their segments, recording any coalescences that occur as a consequence.

Their respective pseudo-code is quite short, but their detailed description is quite long, [as you can see in the Supplementary S1](https://journals.plos.org/ploscompbiol/article/file?id=10.1371/journal.pcbi.1004842&type=printable#%FE%FF%00R%00p%00c%00b%00i%00.%001%000%000%004%008%004%002%00.%00s%000%000%001) of  [Kelleher et al. (2016)](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004842). Consequently I will not duplicate them into this post: please keep an eye on the original article, thaank you :kissing_heart:


### The coding guidelines

I want my implementation to follow the main guidelines of the C++ STL. What does it mean concretely?

In the C++11 standard it is stated in §25.1 (see the footnotes):

> 3 All of the algorithms are separated from the particular implementations of data structures and are parameterized by iterator types. Because of this, they can work with program-defined data structures, as long as these data structures have iterator types satisfying the assumptions on the algorithms.

Ok, so basically it's saying that we don't want to see any detail about the data structure manipulated by the algorithm. If we manipulate collections of data, they are abstracted to iteratables through the use of iterators. That makes sure that the next colleague with a slightly different data structure will still be able to use our algorithm: abstraction, abstractions, all we want is abstraction!

Two bullet points later, it is stated:

> 5 Throughout this Clause, the names of template parameters are used to express type requirements. If an algorithm’s template parameter is InputIterator, InputIterator1, or InputIterator2, the actual template argument shall satisfy the requirements of an input iterator (24.2.3). If an algorithm’s template parameter is OutputIterator, OutputIterator1, or OutputIterator2, the actual template argument shall satisfy the requirements of an output iterator (§24.2.4). If an algorithm’s template parameter is ForwardIterator, ForwardIterator1, or ForwardIterator2, the actual template argument shall satisfy the requirements of a forward iterator (§24.2.5). If an algorithm’s template parameter is BidirectionalIterator, Bidirectional-Iterator1, or BidirectionalIterator2, the actual template argument shall satisfy the requirements of a bidirectional iterator (§24.2.6). If an algorithm’s template parameter is RandomAccessIterator, Random- AccessIterator1, or RandomAccessIterator2, the actual template argument shall satisfy the requirements of a random-access iterator (§24.2.7).

Argh, this one is tough. All the jargon... dude seriously, the computer could do some communication effort! But well, in essence it says that the name of the types used in the function signature should reflect the constraints that are exerted on the type.

For example, checkout the function `std::any_of`: its signature is:

```cpp
template <class InputIterator, class Predicate>
bool any_of(InputIterator first, InputIterator last, Predicate pred);
```

If you look at the related [cppreference page](https://en.cppreference.com/w/cpp/named_req/RandomAccessIterator), you will see a list of constraints that have to hold when an `InputIterator` is manipulated by the algorithm.

This list of requirements is actually more like a verbal agreement, a human naming convention: the compiler does not explicitly test for those conditions. But C++20 changed the game, and now you can use the [STL concepts library](https://en.cppreference.com/w/cpp/concepts) to sign a written contract with the compiler. If your iterator does not comply the algorithm requirements, you will get a nice, clear and very localized insult from your favorite compiler.

> This contrasts with Python or R codes, that may stop and try to communicate about the bug situation very far from the actual problematic line of code (that's the benefit of compiled languages).


## Implementation

### General intuitions

What is interesting is that directly from the vague description we can already get an idea of the algorithms signature and of the abstractions we will use:

#### Algorithm H interface

- *Simulate the coalescent with recombination*: the return type of the algorithm is some sort of reference on a graph. We may have to infer the return type from the types passed as parameters to the algorithm - or maybe not, let's see! But again: the concrete type of this graph has to remain abstract! We don't want our reusable algorithm to depend on an arbitrary class like `MyAncestralRecombinationGraphImplementation45` :smile:
- *for a sample of $n$ individuals*: mhhh interesting, we have a sequence of individuals. God knows what datatype this is supposed to be in the user's context! Let's abstract this with iterators of (momentarily arbitrary) type `It1`
- *on a sequence of $m$ sites*: *huho!* a second sequence, but this time we iterate through elements called *sites*... what does that mean, hell if I know... :thinking: Well, same problem, same solution: we also abstract that with iterators of type `It2`!
- *with recombination at rate $r$ per generation between adjacent sites*: :heart_eyes: *hooo* I love that! Do you see why? This sneaky parameter $r$, that swears with puppy eyes that it will remain constant *ad vitam aeternam*, is an insolent liar, and can actually be a more complex function depending of the user context! From what I understand from this definition, it can either be:
    - a simple value $r$ with constant value
    - a function of time, with different values $[r_0,r_1,\dots,r_g]$ for each generation $g$.
    - Or even worse, it could also be dependent on the position along the genome, and change according to what *adjacent sites* the algorithm is currently examining. In other terms, a function of time AND site position!
    - And this function could be deterministic or, always possible with random simulations, it could require some entropy generation!

    :relaxed: It's exactly the kind of problem
    I love to solve! How to handle simultaneously and elegantly these four cases? You see me coming: abstract them! Inside the Hudson's algorithm we don't really care how this value $r$ is decided: we will let the user decide by passing a functor to our algorithm, that is a callable with signature `r(int time, It2 position, T generator)`.

> :warning: Please do not use [Object-Oriented Programming](https://en.wikipedia.org/wiki/Object-oriented_programming) here (in the sense of achieving polymorphism through a hierarchy of classes): you will inevitably get stuck into a rigid hierarchy of types and run into impossible [covariant return type](https://en.wikipedia.org/wiki/Covariant_return_type) problems! *Brrr!* :scream_cat:

#### Algorithm H implementation

There are 3 sub-routines to the Hudson algorithm:

- **H1**: The algorithm initialization
- **H2**: An event is triggered, and invokes either algorithm C (for a coalescence event) or R (for a recombination event)
- **H3**: A loop condition: as long as the set of extant ancestors P is not empty, we call H2 again and again. I will chose not to implement this one, as my guess is that this loop is generally the responsability of the client code. However, we will need to define an interface that exposes the condition, something along `bool is_set_of_ancestors_empty()`

Since we are already talking about initializing the algorithm with a specific state and updating its state conditionally to the type of event that is triggered, it kinda makes sense to define a new class for the Hudson algorithm.

> :bulb: classes are wonderful abstractions to represent the state of an object (private data) and carefully control this state by the mean of its behaviors (public methods).

I will dump a whole bunch of code: at this stage, we do NOT want this code to work. Quite the opposite actually: we need to come up with the simplest, **most direct translation** of the original pseudo-code. I don't want something that the *machine* can understand, I want to stay as close as possible to something a *human* can understand!

What I personally love with C++ and the STL is that we have all the feature we need to write a very human-friendly translation:

```cpp
class HudsonAlgorithm
{
private:
  // the set of extant ancestors
  std::set<...> P;
  // store the coalescence record
  std::set<...> C;
  // counts the number of extant segments intersecting with a given interval
  std::map<..., ...> S;
  // track the cumulative number of links subtended by each extant segment
  BinaryIndexedTree<...> L;
  // next available node
  ... w;
  // clock
  ... t;

public:

  ///
  /// @brief Constructor
  /// @param sample
  /// @return ?
  /// @remark Implements the routine H1 in S1 Kelleher et al. 2016.
  ///
  HudsonAlgorithm()
  {
    // for each individual in the sample
    for(int j = 1; j <= n; ++j)
    {
      // allocate a segment x covering the interval [0, m) that points to node j
      auto x = Segment(0, m, j);
      // record that this segment subtends m−1 links
      this->L[k] = m - 1;
      // insert it into the set of ancestors P
      this->P.insert(x);
    }

    // initialise the map S stating that the number of extant segments in the interval [0, m) is n
    this->S[0] = n;
    this->S[m] -= 1;
    // set the next available node w to n + 1
    this->w = n+1;
    // set the clock to zero
    this->t = 0;
  } // end constructor


  ///
  /// @brief ?
  /// @param ?
  /// @return ?
  /// @remark Implements the routine H2 in S1 Kelleher et al. 2016.
  ///
  void event()
  {
    // find the total number of links subtended by all segments:
    total = L.total();
    // calculate the current rate of recombination
    lambda_r = r(t)*total;
    // calculate the current rate of common ancestor event
    lambda = lambda_r + P.size()*(P.size()-1);

    // simulate timing and type of next event
    std::exponential_distribution<> exp_dis(lambda);
    auto delta_t = exp_dis(generator);
    t = t + delta_t;
    std::uniform_real_distribution<> unif_dis(0.0,1.0)
     if(unif_dis(gen) < lambda_r / lambda)
     {
       // invoke algorithm R
       recombination_event();
     }else{
       // invoke algorithm C
       common_ancestor_event();
     }
  }

  ///
  /// @brief Choose a link uniformly and break it, resulting in one extra individual in the set of extant ancestors.
  /// @param ?
  /// @return ?
  /// @remark Implements the algorithm R in S1 Kelleher et al. 2016.
  ///
  void recombination_event()
  {
    R1_choose_link();
    R2_break_between_segments();
    R3_break_within_segments();
    R4_update_population();
  }

private:

auto R1_choose_link()
  {
    // pick a link h from the total(L) that are currently being tracked
    std::uniform_real_distribution<> unif_dis(1, L.total());
    auto h = unif_dis(generator);
    // ind the segment y that subtends this link
    auto y = L.find(h);
    // calculate the corresponding breakpoint k
    auto k = right(y) - L.total(y) + h - 1
    x = prev(y)
    // does link h falls within y or between y and its predecessor x?
    if(left(y) < k )
    {
      R3_break_within_segments();
    }else{
      R2_break_between_segments();
    }
  }

  auto R2_break_between_segments()
  {
    // big_lambda is equivalent to null
    // simply break the forward and reverse links in the segment chain between them
    next(x) = big_lambda;
    prev(y) = big_lambda;
    // independent segment chain starting with z
    // which represents the new individual to be added to the set of ancestor
    auto z = y;
    R4_update_population();
  }

  // @brief Split the segment such that the ancestral material from left(y) to k remains assigned to the current individual and the remainder is assigned to the new individual z.
  auto R3_break_within_segments()
  {
    // independent segment chain starting with z, which represents the new individual to be added to the set of ancestor
    z = Segment(k, right(y), node(y), big_lambda, next(y));
    if( next(y) != big_lambda)
    {
      prev(next(y)) = z;
    }
    next(y) = big_lambda;
    right(y) = k;
    // update the number of links subtended by the segment y, which has right(z) − k fewer links as a result of this operation
    L[y] += k - right(z);
  }

  auto R4_update_population()
  {
    // update the information about the number of links subtended by this segment
    L[z] = right(z) - left(z) - 1;
    // Insert the segment z into the set of ancestors
    this->P.insert(z)
  }

}; // end class HudsonAlgorithm

```


You notice that at this point, I wrote a bunch of dots here and there. These dots, to me, signal **a type information** about which I'm not certain. Either because I am not sure about the original pseudo-code intention, or because it should not be the responsibility of the algorithm to define that type.


- **Algorithm C**, Common Ancestor event: Choose two ancestors uniformly and merge their segments, recording any coalescences that occur as a consequence.


--------------------------------------

# :books: References

- Kelleher, J., Etheridge, A. M., & McVean, G. (2016). Efficient coalescent simulation and genealogical analysis for large sample sizes. PLoS computational biology, 12(5), e1004842.

- Larsson, D. J., Pan, D., & Schneeweiss, G. M. (2021). Addressing alpine plant phylogeography using integrative distributional, demographic and coalescent modeling. Alpine Botany, 1-15.
