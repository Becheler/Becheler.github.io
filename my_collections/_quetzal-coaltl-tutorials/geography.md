---
layout: tutorial_post
title: Working with heterogeneous landscape
tagline: the C++ Coalescence Template Library
description: Integrating landscape heterogeneity
img: doodles/under_construction_crop.png
use_math: true
---

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

## Read an environmental quantity

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
- a vector of ordered time points for each layer, from the oldest to the most recent

```cpp
quantity_type my_quantity( "my_file", std::vector<time_type>{"january_present"} );
```

>**Note** here we use only one point time. In another setting, you would probably
want to write things like this:
```cpp
quantity_type my_quantity( "my_file", {2001,2002,2003,2004,2005,2006,2007,2008,2009,2010} );
```

### Retrieve the set of inhabitable demes

When considering a spatial grid, it is quite usual to consider that each cell
of the grid is a deme. So to represent each deme with a unique identifier,
we can use the centroids of each cell.

>**Note**: we could use the raw/column indices of the spatial grid as indices
of the demes, but doing so we would be putting too much emphasis on the grid
representation and loosing the geographic intuition. Emphasizing details is
typically what should be avoided in software design.

Moreover, we are generally interested in representing only demes that are inhabitable.
Typically we do not want to pay for representing ocean cells in the simulation context.
In worldclim datasets, oceans environmental values are undefined, so to get the continental
demes we have to retrieve only the centroids of the cells for which the environmental data is defined.

This is exactly the purpose of the `geographic_definition_space` function:

```cpp
auto space = my_quantity.geographic_definition_space();
```

We can iterate over this geographic space. The following lines prints out the
geographic coordinates of the continental demes:

```cpp
for(auto const& it : space){
  std::cout << it << std::endl;
}
```

Importantly, this collection of inhabitable demes is typically what you need to
[construct dispersal models](tuto_dispersal.md) for spatially-explicit simulations.

Similarly, you can retrieve at any time the time steps related to the dataset
and iterate over it:

```cpp
auto times = my_quantity.temporal_definition_space();
for(auto const& it : times){
  std::cout << it << std::endl;
}
```

### Read the data inside

To retrieve the quantity value at deme $x$ at time $t$,
use the following function by passing the right arguments:

```cpp
for(auto const& t : times){
  for(auto const& x : space){
    std::cout << x << "\t" << t << "\t" << my_quantity.at(x,t) << std::endl;
  }
}
```
An that's it !

### Complete script and compilation

The complete script is given below. Make sure gou give the right paths
on your own system.

```cpp
#include "my_path/quetzal/geography.h"
#include <iostream>
#include <assert.h>
#include <string>

int main()
{

	using time_type = std::string;
	using quantity_type = quetzal::geography::EnvironmentalQuantity<time_type>;
	using coord_type = typename quantity_type::coord_type;

	quantity_type my_quantity( "my_file.tif", std::vector<time_type>{"january_present"} );

	auto times = my_quantity.temporal_definition_space();
	auto space = my_quantity.geographic_definition_space();

	std::cout << "Demic structure for demographic simulation" << std::endl;
	for(auto const& it : space)
  {
		std::cout << it << std::endl;
	}

  for(auto const& t : times){
    for(auto const& x : space){
      std::cout << x << "\t" << t << "\t" << my_quantity.at(x,t) << std::endl;
    }
  }

  return 0;
}
```

When you compile it, make sure that you link to the [gdal library](getting_started#install-gdal) :

```
g++ -Wall -std=c++14 tuto_geo.cpp -I/usr/include/gdal  -L/usr/lib/ -lgdal
```

Then run the script with `./a.out`

## Constructing a multi-variate environment

The joint manipulation of multiple environmental dataset can be tricky: the system has to
guarantee a common geographic subset for which all environmental quantities are defined,
that the temporal ranges of each variable are consistent, that resolutions are identical
across files...

Using multiple EnvironmentalQuantity objects is error-prone, and you should
prefer instead the use of the DiscreteLandscape classm that secures the construction
of a multivariate, temporal, spatial grid.

Most of the concepts are similar to those previously exposed so just read the following code
as an illustration.

Some precisions however:
- You have to give identifiers to the quantities, so you can retrieve them later. These
  identifiers can be of any user-defined type: integers, strings ...
- The quantities retrieved from a DiscreteLandscape have the semantic of a function
  of space and time.
- If you want to run the following script, make sure that your TIFF files are consistent with the
temporal range given in the demonstration code.
- Reprojecting `coord_type` objects to the nearest cell centroid is a precious feature when
  incorporating genetic dataset in the spatial analysis, because it allows you to easily
  reproject your sample in the demic structure.

```cpp
#include "my_path/quetzal/geography.h"
#include <iostream>   // std::cout
#include <string>

int main()bio12
{
  using ID_type = std::string;
	using time_type = unsigned int;
	using landscape_type = quetzal::geography::DiscreteLandscape<ID_type, time_type>;
	landscape_type env( { {"rain","my_file.tif"},
                        {"temperature","other_file.tif"}
                      },
	                    {2001,2002,2003,2004,2005,2006,2007,2008,2009,2010} );

	std::cout << env.quantities_nbr() << " quantities read from files" << std::endl;

  landscape_type::coord_type Bordeaux(44.5, 0.34);
  if(env.is_in_spatial_extent(Bordeaux)) {
    std::cout << "Centroid: " << env.reproject_to_centroid(Bordeaux) << std::endl;
  }

  // Retrieve environmental functions
  auto f = env["rain"];
  auto g = env["temperature"];

  auto times = env.temporal_definition_space();
  auto space = env.geographic_definition_space();

  for(auto const& t : times){
    for(auto const& x : space){
      if( f(x,t) <= 200. && g(x,t) <= 600.){
        std::cout << x << "\t" << t << "\t" << f(x,t) << "\t" << g(x,t) << std::endl;
      }
    }
  }

	return 0;
}
```
