# Quetzal for iDDC: User manual

Some vocabulary here:

* Quetzal refers to the whole framework I developed for iDDC modeling. It is built from different things
* EGGs refer to the little simulation executables that are available. These executables use a configuration files to simulate demography and genealogies.
* CRUMBS refer to the Python library I developed to simplify some data treatment (GIS, ENM/SDM etc) before or after the EGGS are run. The crumbs are best used from the command line or from bash scripts.
* Quetzal-CoaTL refers to the C++ toolbox that I developed and that contains essential components of iDDC simulators. In other terms, the EGGs need quetzal-CoaTL, but you don't have to be aware of that unless you want/need to develop your own EGG.  

## EGGS simulators

### Testing that EGGS simulators compile and work fine in your Docker container

1. Download the image with: `docker pull arnaudbecheler/quetzal-nest`. If this command fails
with a permission error, try `sudo docker pull arnaudbecheler/quetzal-nest`

2. Enter the container with `docker run -it --entrypoint bash arnaudbecheler/quetzal-nest`

3. Once you are in the docker container, there is a `quetzal-EGGS` folder (check its existence with teh `ls` commmand). You can try the following:
  ```
  cd quetzal-EGGS
  mkdir build
  cd build
  cmake ..
  cmake --build .
  ctest
  ```

At this point, the EGGS should be locally built (meaning the binaries are present in the `build/src` folder)
and the tests should be running and passing (meaning the binaries are running as expected).

### Testing that EGGS are present system-wide

In the previous section I made you build locally the EGGs binaries for testing purpose.
But outside of testing, you don't want to do that. In the `quetzal-nest` docker image, all EGGs binaries come pre-installed in `usr/local/`.
You should be able to call the eggs binaries from anywhere with for example `/usr/local/quetzal-EGGS/EGG1 --help`

### Testing the EGGS on a local machine with custom files

iDDC is a computational intensive workflow, and most of the time you will need a
cluster for the final analysis (for example, the Open Science Grid).
However, testing on you local machine
is an important part of the work.

To this end, I recommend to copy the files that would be part of a job to a folder on your
computer, and then start the container from this folder with this invocation:

```
docker run --user $(id -u):$(id -g) --rm=true -it \
  -v $(pwd):/srv -w /srv \
  arnaudbecheler/quetzal-nest:latest /bin/bash
```

Then you can invoke the simulators with their respective configuration files and visualize
the output with the crumbs functionalities.
