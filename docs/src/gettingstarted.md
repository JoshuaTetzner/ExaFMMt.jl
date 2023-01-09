# Installation

The package can be installed with the package manager by 

```julia
import Pkg
Pkg.add("https://github.com/JoshuaTetzner/exafmm.git")
```

# First steps

A simple Laplace FMM of a random distribution of charges is computed by the following code:

```julia
using exafmm

sources = rand(100, 3)
targets = rand(100, 3)
charges = rand(100)

A = setup(sources, targets, LaplaceFMMOptions())
y = A*charges
```

The variable `A` resembles the FMM-matrix and can be multiplied by a vector of `Float64` charges with 100 elements. 
