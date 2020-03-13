---
layout: decrypt
title: Decrypt
tagline: speciation versus isolation by distance
description: application
use_math: true
---

# Summary

Decrypt is a tool allowing to shed light on systems where cryptic diversity and
isolation by distance are two competing hypothesis. Decrypt can help understanding
if the genetic structure detected under the MultiSpecies Coalescent, MSC, could possibly
be explained by the intra-species spatial structure.

It can be seen as a way to automate MSC robustness analyses for different realistic demographic histories
and spatial sampling schemes.

The Decrypt C++ demogenetic simulation core has been developed using the Quetzal library.
It generates a spatially explicit demographic history incorporating environmental
heterogeneity and random population persistence in unsuitable areas.
At sampling time, it simulates gene trees under different sampling schemes.
Then, sequences are simulated along the gene trees, and BPP is run for species delimitation.
