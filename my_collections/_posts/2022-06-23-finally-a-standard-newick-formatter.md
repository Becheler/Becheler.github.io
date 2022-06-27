---
layout: post
title: A modern C++ Newick tree formatter
subtitle: Ou la révolution des pointeurs
date: 2022-06-23 13:30
description: Approaching population genetics with a modern C++ design
img: doodles/revolution_des_pointeurs.png # Add image post (optional)
fig-caption: (Fall) back to the trees!  # Add figcaption (optional)
tags: [ecology, evolution, biogeography, coalescence, quetzal, phylogeny, newick, C++]
sticky: false
use_math: true
---

:seedling: Recently, I began to work on a new project that requires to manipulate species trees,
using Newick representation as input/output. I was tying to track down a series of
bugs in the legacy code, but my task was made utterly complex by uncooperative
pointers who had invaded all interfaces, conquered the core of the code, and corrupted
pretty much all classes who were maybe [a bit too friendly](https://softwareengineering.stackexchange.com/questions/132403/should-i-use-friend-classes-in-c-to-allow-access-to-hidden-members) with the invaders :guardsman:

In my [Quetzal library](https://becheler.github.io/softwares/quetzal-CoalTL/home/)
where I try to gather reusable components for population genetics,
I had to tackle similar problems to save genealogies simulated under different
scenarios- and I was not too happy with the solution I had written at the time:
it required to duplicate the code for every new use case! :disappointed:

So for this new project, rather than quadruplicating the code, I decided it was
time to do things well and come up with a unique, truly generic, reusable Newick formatter,
and share it with the community :muscle: Sharing is caring :kissing_heart:

And also, because it's a learning process that deserves to be shared, I thought it
could be a cool opportunity to show what software design rules guided my coding decisions :books:

In this post, you will learn about:

- the Newick format and its variants
- the cost of not having a standard modern C++ library solution for population genetics
- basic design concepts I found useful to achieve my goals
- how test-driven development helped me enforcing modular design
- how to use our new Newick tree formatter! :hugs:

---
> I know your time is precious! :hourglass_flowing_sand:
  * If you are just looking for the code, you can find it [on Compiler Explorer!](https://godbolt.org/z/6fbT93eTT).
  * I will surely update the code in the future, check for updates in my
 [Quetzal library](https://github.com/Becheler/quetzal-CoaTL).
   * If you find a bug :bug:, have a suggestion, or would like a new feature :rocket:, ask in the comment section :point_down:

---

* TOC
{:toc}

## The current situation

If you have been coding for population genetics, I guess you are familiar with the
[Newick format](https://evolution.genetics.washington.edu/phylip/newicktree.html)
to describe trees using nested parentheses. If a parent node *A* has to children *B*
and *C*, then its (non-unique) Newick formula is `(B,C)A;`. Easy. The format
comes with a number of variants:
* with branch length annoted: `(B;20,C:10)A;`
* with anonymous nodes `(,);`
* with root branch length specified: `(B:20,C:10)A:0.0;`
* and other variants (PAUP, TreeAlign, PHYLIP ...) like `(B:20,C:10)A[with a [nested comment]]:0.0;`

## The problem

Here is the catch: there is **no** modern C++, generic, reusable, tested implementation available, even if:

* this format has been around since **1986** (*before I was even born!* ::neckbeard::)
* it is the most readable format (although not the most efficient)
* is widely popular among researchers in phylogenetics
* it is widely used in research programs

## The costs and risks of recoding

Not having a standard tool to perform a standard task comes with a number of costs and risks,
that tend to be associated to *rather strong feelings* towards **ourself** ... and our unfortunate compilers friends.

![Unworthy!]({{site.baseurl}}/assets/img/doodles/unworthy.jpg#center)
<p align="center" style="color:grey"> <i> Through your arrogance and stupidity, you've opened these peaceful realms<br> and innocent lives to the horror and desolation of war! You are unworthy of these realms,<br> you're unworthy of your title, you're unworthy... of the loved ones you have betrayed! </i></p>



### Time is money, researchers have none.

If you want to save or load trees in the newick format, you would have to recode
1. the node data access logic *(how do you access data in your Tree class)*
2. the recursion logic *(how you traverse your tree from the root to the tips)*
3. the formatting logic *(the grammar - what is the correspondence between the tree topology and the Newick string characters)*

In short: You. Have. To. Freaking. **Recode. Everything** :weary: Probably like a
gazillion of C++/bio researchers before you :grimacing:

Well. That's *really bad*. At the scale of our academic community, it is a lot
of cumulated time that has been lost in reinventing the wheel. And time is money.

### High chance to introduce new bugs

You may think *it's okaaay, it's easy to recode anyway* :angel:

And you would be right! You can surely find a way to dump a bunch of
nested parenthesis, letters and number in a stream! :wink:

:ambulance: But have you though about everything that can (and will!)
go wrong?
* Unbalanced parentheses
* Unbalanced comment brackets
* Conflicts between format flavors (some flavors allow nested comments, other not)
* Floating number precision
* Labels containing forbidden characters like `)`,`]`, `,` ...

[A recent work](https://scholarworks.alaska.edu/handle/11122/10178) showed that out
of 4 popular genetic simulators only one performed correctly, the 3 others had
statistical errors in their simulated distributions. Nobody knows where the
bugs are. All programs happen to read, write and manipulate trees :thinking: Suspiciouuus. Could the
bug be hidden in their tree formatting code? :detective: That will be difficult
to test and tell if the formatter code is embedded within the rest of the software
and can not be tested in isolation! :boom:

Still thinking we don't need a standard, generic, thoroughly tested implementation? :wink:

### Small bug can have real-world impacts

Our programs don't exist in a cloud :nerd_face: :unamused:

Science projects have real-world applications and any errors that goes around the
code comes around *at some point*. Programs that use Newick format tend to care about the formation and delimitation of species, and their conclusions can inform the status of **endangered species**, **provide guidelines to decision-makers** and help decide on how to **use taxpayer's money**.

You better get it right and bug-free if you want to save the arctic :penguin: Yes,
I just made a joke about climate change :no_mouth:

## It is actually a design problem

![Buggy bloody battlefield!]({{site.baseurl}}/assets/img/doodles/solved_issues.png)

#### The ebb and flaws of untestable research softwares

:children_crossing: To be fair it's okay if you get bugs because of a messy design:
everybody knows our programs often look like a bloody battlefield where programmatic catapults, antique trebuchets
and futuristic ovnis join the battle against the Cloud of Unknowing.

Science is amazing :rocket:

> What is not ok is that you had to recode this feature by lack of a community standard.

Modular design - that is, the art of programming truly independent and testable entities -
is a complex matter, and its cost should be shared across academic communities.
Here I show a way out.

#### Why you should get familiar with software design culture

Sources of error in a hand-coded Newick formatter will surely get
compounded with bugs from other classes that exist *a bit too close* from the
formatter's code. Learning how to disentangle this blob will require at least
some familiarity with design concepts.

If you are not into modern C++ or software design,
(what I can understand :face_with_head_bandage:),
then you may not have heard of the
[Single Responsibility Principle]({%post_url 2021-08-06-make-code-surgery-easy-with-SRP%})
or you may underestimate the importance of a strong
[separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns) in a software.
They are **essential** to moving to the next stage of computational biology!

So take your time, read about the [Five SOLID principles]({%post_url 2018-10-20-how-to-write-solid-code %}),
read the papers of [Robert C. Martin, or “Uncle Bob”](http://principles-wiki.net/collections:robert_c._martin_s_principle_collection), and know how to recognize, name, and fix bad
smells in your code: [rigidity, fragility, viscosity, and immobility](https://medium.com/@trionamoynihan/solid-design-principles-eec367b2b8).

#### Acknowledge that there is a cultural problem too

The unfair truth is that I really don't think it's the fault of the programmer
(usually an over-worked, stressed and underpaid PhD student :tired_face:) if there is a
bug in the matrix: our **entire community** has been unable to generate the
reusable code solutions the programmer could have used.

> *When most of our C/C++
programs do very similar things, isn't it intriguing that we don't we have shared, reusable
libraries yet?*

Why is this? From my perspective, it's because these reusable solutions generally
rely on higher degrees of abstraction, and researchers tend to be uncomfortable
around such code as:

* it requires some knowledge of modern (post-C++11) C++ *(smart pointers, templates)*
* learning modern C++ takes time *(steep learning curve)*
* code abstractions are sadly perceived as far off the biological case at
  hand *(eg, the species :penguin:)* and as such deemed undesirable.

You see the vicious circle?

1. We use the biological argument (*we need to focus on the biological reality*)
2. to dismiss a common engineering solution (*we need reusable and testable code absractions*)
3. to a well-known problem (*we have too many buggy duplicated untested codebases*)
4. but doing so we actually reinforce the biological crisis (*buggy code can't help endangered species*) that we used as an excuse (*back to 1*).

So, how do we short-circuit this circular problem? With modern C++ design, of course :smiling_imp:

#### Learn to recognize the smell of poor design...  

Counter-intuitively, a lack of abstraction has rather concrete ways to manifest itself into the code:

- Raw pointers haunting the interfaces (e.g. a function signature close to `*Node my_function(Node& n)`)
- Access to member functions or variables classes (e.g. `node->left`) *from inside* the Newick grammar logic
- And *proooobably* a debugging phase involving lots of segmentation faults (`core dumped`) if you are lucky ...
- ... or invisible errors if you're unlucky :poop:
- And to make the debugging worse, the surest sign of a lack of design is that
  since the code is now a big blob of pointers and friend classes, there is no identifiable component
  to isolate in a test unit :see_no_evil:

Sounds familiar? :rofl: We've all been there :hugs:

#### Instead, maybe try ...

The solution is going the other way around:

- Begin with writing the unit tests: they should only test the Newick formatter.
- It means that the formatter **can not** include or interact with your real `Node` class:
  **instead**, define a minimalist class in the unit test.
- It means that the formatter code that you will have to write will **necessary**
  be more abstract than what you are used to, and you may feel a bit lost or not
  know where to go: don't flinch here!
- Use online communities like Stack-overflow
  (or [developpez.net](https://www.developpez.net/forums/f19/c-cpp/cpp/) if you're
  a french-speaker) to present your test code and share what you want to achieve.
- Thanks to these communities I could have feedback from seasoned experts who in real life were
  members of the C++ standardization committee, famous authors, or developers of some of the most
  important tools we have out-there. Trust their feedback!

## Diving into coding

![Diving into coding]({{site.baseurl}}/assets/img/doodles/diving_into_coding.jpg)


### What we are aiming at :dart:

When I have a new feature to implement, I look online to see if some code already exists
so I don't reinvent the wheel. However, my ability to find and reuse such feature
depends heavily on *how* it was initially coded. What I'm looking for is a carefully
crafted, self-contained algorithm (or a class) that embeds its essential responsibilities
but abstracts all non-essential aspects of the problem.

If you want more details about the why, check [my article on the Single Resonsability Principle]({%post_url 2021-08-06-make-code-surgery-easy-with-SRP%}).

In a few words, I'm looking for a code with a **satisfying level of abstraction**
that allows me to simply copy-paste the code and inject my own context-specific
details into it without modification.

> The [C++ Standard Template Library](https://en.cppreference.com/w/cpp) is a
brilliant example of such components: whatever I'm doing when I'm using STL containers like a `std::vector` or
a `std::map` to store my objects or a STL algorithm like `std::accumulate` to sum the element
of an iterable, I never, *never*, **never** had to modify the STL source code.
Absolutely reusable containers, algorithms, iterators and functors: this is
absolute genius! :nerd_face:
>
> That's why the STL is now kinda synonym with modern C++: why would you code
without this incredible resource?
>
> It's **light**, **efficient**, **flexible**, **extensible**, **reusable**, **testable**...

:dart: I'm looking for **this** kind of standard population genetics algorithms!
**The gold standard of research software engineering.**

Let's try to go there together! :rocket:

### Let's code!

As I was saying, I want the test to be minimal:

1. Create a dumb topology with a (poorely designed) Node class
2. Configure the formatter to be able to access this class interface
3. Expose the formatter interface to the depth first search algorithm
4. Compute and retrieve the formula.

#### The Node class

Let's consider a very  basic node class, with a data field, a reference to the parent
node (for backtracking) and two references on children nodes (implicit assumption of a binary tree).

```cpp
// Simplistic tree for testing
struct Node
{
  Node *parent;
  Node *left;
  Node *right;
  char data;

  // the DFS algorithm

}; // end of class Node
```

:no_entry: Please do NOT reuse this class in real-world projects! It's intentionally
close to commonly found implementations, but it's **not** a good design! For example,
you should avoid as much as possible raw pointers: they lack the syntax of [ownership](https://stackoverflow.com/questions/49024982/what-is-ownership-of-resources-or-pointers) (*that is, the responsibility for cleanup*).
Instead, use [smart pointers](https://en.cppreference.com/w/cpp/memory/unique_ptr), they are so much safer!

:biohazard: That being said, using raw pointers here serves the illustration by
offering a syntax the readers are familiar with, and show that it is actually possible
to contain the flood of pointers behind a strong-enough interface - and avoid them to contaminate the code further!


#### The Depth-First Search Algorithm

The reason to implement the DFS *outside* of the Newick Formatter is that with the current
standard of the language (C++20) it is not possible to offer a DFS that will work
for any client class:
- some programmer may store children of a parent `Node` in an iterable collection (like `std::vector<Node>`)
- others may implement instead two data members to store the kiddos (`this->left` and `this->right`)
- since C++ lacks [reflection](https://stackoverflow.com/questions/359237/why-does-c-not-have-reflection),
  it is impossible to have iterators on the members of a class, and so it's impossible
  to have a consistent syntax for both cases.
- At the end, it is simply not the responsibility of the Formatter to chose what syntax should work for
  iterating on the children of a node ([Single Responsibility Principle]({%post_url 2021-08-06-make-code-surgery-easy-with-SRP%})), and so this syntax should
  be exported outside of the Formatter class ([Dependency Inversion Principle](https://deviq.com/principles/dependency-inversion-principle)).

In clear, we will build a formatter to be able to access the member data of our `Node`
class, and then we will expose the formatting operations through 3 functors (callable objects):
- `post-order()`,
- `pre-order()`,
- `in-order()`

and pass these functors to our DFS who *knows exactly* when it is supposed to call them when
iterating on a node's children.

```cpp
struct Node
{
  // ...

  // The DFS with 3 generic callable parameters
  template<class Op1, class Op2, class Op3>
  void depth_first_search(Op1 pre_order, Op2 in_order, Op3 post_order){
    pre_order(*this);
    if(this->left != nullptr && this->right != nullptr)
    {
      this->left->depth_first_search(pre_order, in_order, post_order);
      in_order(*this);
      this->right->depth_first_search(pre_order, in_order, post_order);
      in_order(*this);
    }
    post_order(*this);
  }
} ;
```

#### Building a test topology

Since we have our dummy class, we can build a dummy topology to play with:

```cpp
int main(){

  /* Build the topology :
  *             a
  *           /  \
  *          /    c
  *         /    / \
  *        b    d   e
   */

   Node root; root.data = 'a';
   Node b; b.data = 'b';
   Node c; c.data = 'c';
   Node d; d.data = 'd';
   Node e; e.data = 'e';

   root.left = &b ; b.parent = &root;
   root.right = &c; c.parent = &root;
   c.left = &d ; d.parent = &c;
   c.right = &e; e.parent = &c;

   // ...
}
```

#### Testing the formatter with the simplest case

Our formatter's logic just needs 4 informations:

- check if a node has a parent
- check if a node has children
- what label to print for a given node
- what number to print as the branch length for a given node

> :bulb: We use C++20 [concepts!](https://en.cppreference.com/w/cpp/language/constraints)
>
> This feature allows to test at compile-time if a type fulfills the requirements we expect them to fulfill.
> For example:
> - To enforce the signature of a function evaluating a `Node` and returning a boolean, we can use a `std::predicate<Node>`.
> - To enforce the signature of a function evaluating a `Node` and returning a type convertible to `std::string`, we
>   defined the `Formattable<Node>` concept.

At this point, all non-formatting operations are defined out of the formatter class,
what makes it truly reusable:

```cpp
  // in main ...

  // These functors interface the formatter with arbitrary user tree types
  std::predicate<Node> auto has_parent = [](const Node& n){return n.parent != nullptr;};
  std::predicate<Node> auto has_children = [](const Node& n){return n.left != nullptr && n.right != nullptr;};

  // These functors are the simplest case of formatting and will just print the topology
  newick::Formattable<Node> auto no_label = [](const Node& n ){return "";};
  newick::Formattable<Node> auto no_branch_length = [](const Node& n){return "";};

  // Configure the formatter
  auto fmt = make_formatter(has_parent, has_children, no_label, no_branch_length);
  // Expose its interface to the arbitrary class-specific DFS algorithm
  root.depth_first_search(fmt.pre_order(), fmt.in_order(), fmt.post_order());

  // Retrieving the resulting string
  assert(fmt.get()  == "(,(,));");
```

#### Non-trivial data acquisition and formatting

At this point you may consider actually printing useful information :rofl:

Good news: you can actually define the formatter labels **as you see fit**. As long as they take
a `Node` as a argument and return something convertible to a `std::string`, it's *fiiine*! :thumbsup:

So here I emulated what generally happens in a real population genetics simulator:
you simulated quantities and branch lengths under an arbitrarily complex random distribution,
and now you want to visualize it.

Well, you can do that too with our new Formatter:

```cpp

// Get a seed for the random number engine
std::random_device rd;
// Standard mersenne_twister_engine seeded with rd()
std::mt19937 gen(rd());
// Arbitrary branch length distribution
std::uniform_real_distribution<> dis(0.0, 2.0);
// Random data generator, capturing the RNG and the distribution
newick::Formattable<Node>
auto branch_length = [&gen,&dis](const Node& n){return std::to_string(dis(gen));};
// More sophisticated label formatting
newick::Formattable<Node>
auto label = [](const Node& n ){return std::string(1, n.data) + "[my[comment]]";};
// Configure the formatter
auto fmt = make_formatter(has_parent, has_children, label, branch_length);
// Expose it to the DFS
root.depth_first_search(fmt.pre_order(), fmt.in_order(), fmt.post_order());
// Retrieve the Newick formula
std::cout << fmt.get() << std::endl;
```
And as an output you obtain:

```
(b[my[comment]]:1.733647,(d[my[comment]]:1.572409,e[my[comment]]:0.929093)c[my[comment]]:1.475975)a[my[comment]];
```
Isn't life beautiful? :hugs:

#### Even further customizations: policy classes!

As we saw in the introduction, Newick format has a number of variants, as every
program using it comes with its own assumptions on the format validity. For example,
the `TreeAlign` program does not allow nested comments, and requires that the root
branch is set to 0.0.

How to allow users of our class to:
1. specify what specific format to use
2. while allowing the community to extend the Formatter behavior towards new variants
3. without having them to recode the entire formatter?

:tada: It's exactly what [policy-based design](https://en.wikipedia.org/wiki/Modern_C%2B%2B_Design)
is for!

> A **policy class** is a class that specify/isolates a set of behaviors that are orthogonal to the rest
of the program.

:seedling: Is it a bit abstract? Let's get a more concrete example: a `TreeAlign`
policy does not require to redefine the entire behavior of the Formatter:
rather, you just need to *somehow* tell the basic formatter that it may have to treat
comments a bit differently, and that it may have to use a different way to treat a branch length when
it finds a root node.

The way to do that in the C++ implementation would be to write
a dedicated `TreeAlign` structure which only responsibility is to encapsulate these behaviors (SRP):

```cpp
///
/// @brief Set a root node branch length to zero. Remove all nested comments.
///
struct TreeAlign
{
  // Set explicit null branch length for root node
  static inline std::string root_branch_length() { return ":0.0";}

  // Remove comments that are nested, keep comments of depth 1
  static inline std::string treat_comments(const std::string &s)
  {
    return remove_comments_of_depth<2>::edit(s);
  }
};
```

The Formatter, when it's called with the `TreeAlign` policy, will ask the structue
to give it access to the right function
at the right moment. For example, inside the Formatter class in the post-order
operation code, you will find something along these lines:

```cpp
if( !node.has_parent())
{
  formula += get_label(node);
  // returns "0.0" if policy_type = TreeAlign, or "" if a different type is used!
  formula += policy_type::root_branch_length();
}
```

The magic of policy-based design is that these decisions are actually formed
**at compile-time!!!** So you're not trading flexibiity for efficiency: you are
actually getting **both**! :moneybag:

Even better, as a user of our Formatter class, you don't need to care about any of the above,
you just need to pass the right policy to the formatter builder :moneybag::moneybag:

```cpp
// Writes a root node branch length with a value of 0.0 and disable nested comments
using flavor = quetzal::format::newick::TreeAlign;
using newick::make_formatter;

auto fmt = make_formatter(has_parent, has_children, label, branch_length, flavor());

a.depth_first_search(fmt.pre_order(), fmt.in_order(), fmt.post_order());

std::cout << fmt.get() << std::endl;
```

> **Output:**
>
>`(b[my]:0.142450,(d[my]:0.224856,e[my]:1.019509)c[my]:1.720561)a[my]:0.0;`

Isn't it absolutely delightful? :hugs:

I *looove* modern C++: it allows us to encapsulate the details of our real-case troubles into shiny bubbles of
beauty, simplicity and efficiency! Isn't it what code should be after all? :revolving_hearts:

![Bubble double trouble]({{site.baseurl}}/assets/img/doodles/bubble_double_trouble.jpg#center)
