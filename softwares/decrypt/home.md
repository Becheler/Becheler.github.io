---
layout: main
title: Decrypt
tagline: speciation versus isolation by distance
description: application
use_math: false
---

**Cryptic species or deep spatial structure?**

Better inform your **taxonomic changes**.

Test if your **species delimitation** is **robust to spatial sampling**.

![DECRYPT](/draw/logos/decrypt.png)

Decrypt is a tool allowing to shed light on systems where **cryptic diversity** and
**isolation by distance** are two competing hypothesis. Decrypt can help understanding
if the genetic structure detected under the *MultiSpecies Coalescent* (**MSC**) could possibly
be explained by an intra-species spatial structure scenario.

It can be seen as a way to automate MSC robustness analyses for different realistic demographic histories
and spatial sampling schemes.

The Decrypt C++ demogenetic simulation core has been developed using the [Quetzal library](/pages/quetzal).
It generates a **spatially explicit demographic history** incorporating environmental
heterogeneity. At sampling time, it simulates gene trees under different sampling schemes.
Then, sequences are simulated along the gene trees, and BPP is run for **species delimitation**.
