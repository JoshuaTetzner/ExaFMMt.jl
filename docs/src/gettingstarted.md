# Installation

The package can be installed with the package manager by 

```julia
import Pkg
Pkg.add("https://github.com/JoshuaTetzner/ExaFMMt.jl.git")
```

# First steps

A simple Laplace FMM of a random distribution of charges is computed by the following code:

```julia
using ExaFMMt
sources = rand(Float64, 100, 3)
targets = rand(Float64, 100, 3)
charges = rand(Float64, 100)

A = setup(sources, targets, LaplaceFMMOptions())
y = A * charges
```

The variable `A` resembles the FMM-matrix and can be multiplied by a vector of `Float64` charges with 100 elements. 
