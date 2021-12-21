---
layout: software
title: Quetzal-CoalTL
tagline: the C++ Coalescence Template Library
description: Quetzal-CoalTL home
img: logos/quetzal-coaltl-fa.svg
redirect_from: pages/quetzal
---

The Quetzal **Coal**escence **T**emplate **L**ibrary is a toolbox gathering
**C++ code snippets** that can be **combined** to build coalescence-based, spatially explicit simulators
for inference.

C++ can be intimidating, and we don't want you to cut you hands with this bunch of sharp tools and recusant concepts: for more docile and ready-to-use simulators, check our [Quetzal-EGGs](/quetzal-EGGS/home.md)!

Still with us? Fantastic! Let's get into it.

---------------------------------------------
## Tutorials


### Forward-in-time demographic simulations

[How to use different strategies for simulating populations dispersal:](/tutorials/demography.md)

- Individual-based dispersal in small populations
- Mass-based dispersal for large populations

[How to integrate landscape heterogeneity in the analysis with GIS:](/tutorials/geography.md)

- For retrieving a demic structure
- For constructing multivariate, spatially explicit, temporally changing landscapes.

[How to construct niche functions](/tutorials/niche.md)
- Enable mathematical composition of functions of space and time using expressive
- Coupling environment, growth model and stochastic sampling.

 How to represent dispersal models:

  - using library-defined distance-based dispersal models
  - implementing user-defined dispersal models

### Backward-in-time coalescence simulation

How to think about coalescence graphs:

- using user-defined data structure (that is, the graph nodes)
- using user-defined ancestral relationship (that is, the graph edge)

How to coalesce forests in a spatially explicit framework

- using the Kingman coalescent approximation (binary merges)
- using the multiple merger for small populations

{% for post in paginator.posts %}
<article class="post">
  {% if post.img %}
    <a class="post-thumbnail" style="background-image: url({{"/assets/img/" | prepend: site.baseurl | append : post.img}})" href="{{post.url | prepend: site.baseurl}}"></a>
  {% else %}
  {% endif %}
  <div class="post-content">
    <h2 class="post-title"><a href="{{post.url | prepend: site.baseurl}}">{{post.title}}</a></h2>
    <p>{{ post.content | strip_html | truncatewords: 15 }}</p>
    <span class="post-date">{{post.date | date: '%Y, %b %d'}}&nbsp;&nbsp;&nbsp;—&nbsp;</span>
    <span class="post-words">{% capture words %}{{ post.content | number_of_words }}{% endcapture %}{% unless words contains "-" %}{{ words | plus: 250 | divided_by: 250 | append: " minute read" }}{% endunless %}</span>
  </div>
</article>
{% endfor %}

{% include pagination.html %}
