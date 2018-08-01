---
layout: quetzal
title: Quetzal Tutorials
tagline: the C++ Coalescence Template Library
description: Integrating landscape heterogeneity
use_math: true
---

# Integrating spatially-explicit landscapes and environmental heterogeneity

Quetzal is mainly designed to simulate discrete populations in a discrete space.
Of course you can still manually define a couple of populations with no spatial structure
like in [this tutorial](tuto_demography.md). You could add to these populations a
*certain form* of spatial structure when defining
the migration rates between them. This can work for a reasonable number of populations.

However, **a large number of populations is cumbersome to define and to manipulate.**

And you certainly consider to **define some model quantities as functions of the environment**.

So what you actually need is:
- tools that ease the definition/manipulation of a high number of populations.
- to read some data files containing the relevant environmental information
- an easy way to retrieve and to manipulate the environmental information across the simulation.

Quetzal features were designed to answer these needs.

## Download geographic datasets

First you will need a geographic dataset to read. [Go to worldclim](http://worldclim.org/version2)
and download the 10-minutes average temperature. We will focus here on the January month data file.

> **Important:** Quetzal does not aim to be another GIS software. It aims at easing
your life concerning spatial coalescence softwares. For this reason, it supports only
GeoTiff files that meet the worldclim standard. Contact us if you have any trouble.

> GeoTiff is a public standard that allows to describe cartographic information,
like map projection coordinate systems, ellipsoids, datum, that is associated to
TIFF pictures like satellite imagery, elevation maps, climate data...

## Prepare your script

So open a new text file, give it a nice name like ```tuto_geo.cpp``` and let's write
some code!

First you need to include the ```geography``` module and the STL input/output support
before to declare the main function where we will write our code:

```cpp
#include "path_to_quetzal_directory/quetzal/geography.h"
#include <string>
#include <iostream>

int main
{
  // write things here

  return 0;
}
```

## Read the environmental quantity

### About the temporal dimension

In Quetzal geographic classes, the temporal dimension is represented by the depth
of the dataset. That is, when we have $t$ layers in the GeoTiff file, the first layer
represents the oldest data, and the last layer the most recent data.

The dataset we uploaded from worldclim has only one layer of data,
because it represents "present" quantities for each month, averaged over 1970-2000.

>**Note:** If you want to concatenate these 12 months-data to build a 12-layers deep dataset
that could represent a year, do it using another software. The raster package in R will
be perfectly suited.

So we can represent this singular time-point by anything (an integer, a hash ...) but for sake of clarity,
we will here use a simple string and name the time-point `january_present`
We use a type aliases to make this choice clear:

```cpp
using time_type = std::string;
```

### Construct your spatial object

Then we want to use a Quetzal tool that allows to represent this geospatial data.
We can use the `EnvironmentalQuantity` class. It takes as a template parameter
the type you want to use to represent the temporal dimension (that is, in this example,
  a `std::string`, or equivalently a `time_type`). Let's make things clear:

```cpp
using quantity_type = quetzal::geography::EnvironmentalQuantity<time_type>;
using coord_type = typename quantity_type::coord_type;
```
The second line automatically retrieves the type used in Quetzal to represent
geographic coordinates and assign a new type alias. This type
encapsulates a lot a troubles, like projection system, great circle distance computation...

After these definitions, you can finally build your quantity, giving to the constructor
- the path to the data
- a vector of ordered time points for each layer (from the oldest to the most recent)

```cpp
quantity_type bio1( "../test_data/bio1.tif", std::vector<time_type>{"january_present"} );
```

>**Note** here we use only one point time. In another setting, you would probably
want to write things like this:
```cpp
quantity_type bio1( "../test_data/bio1.tif", {2001,2002,2003,2004,2005,2006,2007,2008,2009,2010} );
```

### Retrieve a demic structure

Now
auto times = bio1.temporal_definition_space();
auto space = bio1.geographic_definition_space();
