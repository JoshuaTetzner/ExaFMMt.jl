# ExaFMMt
[![Docs-stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JoshuaTetzner.github.io/ExaFMMt.jl/stable/)
[![Docs-dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JoshuaTetzner.github.io/ExaFMMt.jl/dev/)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/JoshuaTetzner/ExaFMMt.jl/blob/master/LICENSE)
[![CI](https://github.com/JoshuaTetzner/ExaFMMt.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JoshuaTetzner/ExaFMMt.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/JoshuaTetzner/ExaFMMt.jl/graph/badge.svg?token=RDRQTBWQS3)](https://codecov.io/gh/JoshuaTetzner/ExaFMMt.jl)

## Introduction

This package wraps the [exafmm-t](https://github.com/exafmm/exafmm-t) library for Julia.
Since Julia cannot natively call C++ functions, a C interface was added to [exafmm-t](https://github.com/exafmm/exafmm-t) in the fork at [JoshuaTetzner/exafmm-t](https://github.com/JoshuaTetzner/exafmm-t/tree/feature/c_interface). The binary is built and published via [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil) and registered as [Exafmmt_jll](https://github.com/JuliaBinaryWrappers/Exafmmt_jll.jl) in [JuliaBinaryWrappers](https://github.com/JuliaBinaryWrappers/). 

Since [exafmm-t](https://github.com/exafmm/exafmm-t) uses Unix-only functions, a Windows build is not available. Recommendations on how to get Windows builds working are always welcome. Please open an issue on this repository.  

## Fast Multipole Method (FMM)
The FMM improves the complexity of the matrix-vector product 

$$Ax = y$$

from $\mathcal{O}(N^2)$ to $\mathcal{O}(N)$, where $A$ is the interaction matrix of points that evaluates the Green's function for a Laplace, Helmholtz, or modified Helmholtz kernel. 

A common application of the FMM is the Boundary Element Method (BEM). Further information concerning this topic can be found in the [documentation](https://JoshuaTetzner.github.io/ExaFMMt.jl/dev/details/bem/).

The current JLL build expects a BLAS/LAPACK backend to be loaded through Julia's BLAS stack. If your session has no backend configured, load one such as `MKL` before using `ExaFMMt`.

## Installation 
Installing ExaFMMt is done by entering the package manager (enter `]` at the julia REPL) and issuing:

```
pkg> add https://github.com/JoshuaTetzner/ExaFMMt.jl.git
```

## First steps
A simple Laplace FMM of a random distribution of charges is computed by the following code:

```julia
using MKL # or another BLAS/LAPACK backend configured for your Julia session
using ExaFMMt

sources = rand(Float64, 120, 3)
targets = rand(Float64, 80, 3)
charges = rand(Float64, 120)

A = setup(sources, targets, LaplaceFMMOptions())
y = A * charges
```

The variable `A` represents the FMM matrix and is multiplied by a vector of charges with one entry per source. The result `y` contains the potential at each target. For more examples and details see the [documentation](https://JoshuaTetzner.github.io/ExaFMMt.jl/dev/).

## References
- [1] Wang, Tingyu, Christopher D. Cooper, Timo Betcke, and Lorena A. Barba. *High-Productivity, High-Performance Workflow for Virus-Scale Electrostatic Simulations with Bempp-Exafmm.* arXiv, March 20, 2021. [http://arxiv.org/abs/2103.01048](http://arxiv.org/abs/2103.01048).
- [2] Adelman, Ross, Nail A. Gumerov, and Ramani Duraiswami. *FMM/GPU-Accelerated Boundary Element Method for Computational Magnetics and Electrostatics.* IEEE Transactions on Magnetics 53, no. 12 (December 2017): 1–11. [https://doi.org/10.1109/TMAG.2017.2725951](https://doi.org/10.1109/TMAG.2017.2725951).
