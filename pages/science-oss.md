---
layout: post
title: Science & Open Source Software
subtitle: Boost.Graph, the Quetzal framework and research software
description: Arnaud Becheler's open-source work, maintaining the Boost Graph Library for the C++ Alliance and building the Quetzal C++ framework for computational biology.
---

<style>
.icon-link {
  font-size: 1.2em;
  transition: transform 0.2s ease-in-out;
  display: inline-block;
  margin-right: 15px;
  vertical-align: middle;
  color: inherit;
  text-decoration: none;
}
.icon-link.quetzal-icon {
  font-size: 1.4em;
}
.icon-link:hover {
  transform: scale(1.2);
}
.project-item {
  display: flex;
  align-items: center;
  margin: 15px 0;
}
.project-description {
  display: inline-block;
  vertical-align: middle;
}
</style>

# Science & Open Source Software

## Boost Graph Library

Since January 2026 I maintain [Boost.Graph](https://www.boost.org/library/latest/graph/) for the [C++ Alliance](https://cppalliance.org/people/arnaud/), modernizing one of the oldest Boost libraries without breaking its users.

- **New algorithms:** Louvain community detection, shipped in Boost 1.92 ([PR #453](https://github.com/boostorg/graph/pull/453)).
- **Maintenance:** [110+ pull requests merged](https://github.com/boostorg/graph/pulls?q=is%3Apr+author%3ABecheler) in 2026: lighter dependencies, fixes for long-standing bugs, tests, CI with sanitizers and coverage.
- **Documentation:** migrated to AsciiDoc/Antora.
- **Community:** organizer of the [Boost.Graph Workshop 2026](https://github.com/boostorg/graph/discussions/466) in Paris, and speaker at CppCon 2026 ([talks]({{site.baseurl}}/pages/seminars/)).

I also serve as a Boost Review Manager (Boost.Bloom, Boost.Int128) and I am a member of WG21, the ISO C++ standards committee. More in my C++ Alliance reports: [Q1 2026](https://cppalliance.org/newsmedia/news/joining-community-detecting-communities-making-community/) and [Q2 2026](https://cppalliance.org/newsmedia/news/the-return-of-the-graph/).

## The Quetzal framework

A C++ framework for ecological and evolutionary modeling, started during my PhD:

<div class="project-item">
  <a href="https://quetzal-framework.github.io/quetzal-CoaTL/" target="_blank" class="icon-link quetzal-icon" title="Quetzal-CoalTL"><i class="icon icon-quetzal-coaltl-fa" aria-hidden="true"></i></a>
  <span class="project-description">Quetzal-CoaTL - C++20 template library of reusable components for building spatially explicit coalescence simulators. Published in <em>Molecular Ecology Resources</em> (2019) and <em>Bioinformatics</em> (2020).</span>
</div>

<div class="project-item">
  <a href="https://github.com/Becheler/quetzal-EGGS" target="_blank" class="icon-link quetzal-icon" title="Quetzal-EGGS"><i class="icon icon-quetzal-eggs--fa" aria-hidden="true"></i></a>
  <span class="project-description">Quetzal-EGGS - Ready-to-run simulators built on CoaTL: a demographic history forward in time on a georeferenced landscape, then gene trees backward in time, stored in SQLite.</span>
</div>

<div class="project-item">
  <a href="https://github.com/Becheler/quetzal-CRUMBS" target="_blank" class="icon-link quetzal-icon" title="Quetzal-CRUMBS"><i class="icon icon-quetzal-crumbs-fa" aria-hidden="true"></i></a>
  <span class="project-description">Quetzal-CRUMBS - Python toolkit for the iDDC workflow: paleoclimate data (CHELSA), species distribution models, 21,000 years of landscape reconstruction, and retrieval of simulation results.</span>
</div>

<div class="project-item">
  <a href="https://github.com/Becheler/decrypt" target="_blank" class="icon-link quetzal-icon" title="Decrypt"><i class="icon icon-decrypt_fa" aria-hidden="true"></i></a>
  <span class="project-description">Decrypt - Cryptic species or just subpopulations? Spatial simulations that test how robust species delimitation methods are to population structure.</span>
</div>

---

*All projects are open source and available on GitHub. Contributions and feedback are welcome!*
