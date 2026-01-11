# ExaFMMt
[![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://JoshuaTetzner.github.io/ExaFMMt.jl/)
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/JoshuaTetzner/ExaFMMt.jl/blob/master/LICENSE)
[![CI](https://github.com/JoshuaTetzner/ExaFMMt.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JoshuaTetzner/ExaFMMt.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/JoshuaTetzner/ExaFMMt.jl/graph/badge.svg?token=RDRQTBWQS3)](https://codecov.io/gh/JoshuaTetzner/ExaFMMt.jl)

This package wraps the [exafmm-t](https://github.com/exafmm/exafmm-t) library for Julia.
Since Julia can not natively call C++ functions an C interface was added to the [exafmm-t](https://github.com/exafmm/exafmm-t) which can be found in the fork of the library at [JoshuaTetzner/exafmm-t](https://github.com/JoshuaTetzner/exafmm-t/tree/feature/c_interface). The Binary of this library is build and published via [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil) and registered as [Exafmmt_jll](https://github.com/JuliaBinaryWrappers/Exafmmt_jll.jl) in [JuliaBinaryWrappers](https://github.com/JuliaBinaryWrappers/). 

Since [exafmm-t](https://github.com/exafmm/exafmm-t) uses Unix only functions a Windows build is not available. Recommendations on how to get Windows builds working are always welcome. Please open therefore an issue on this repository.  

## Fast Multipole Method (FMM)
The FMM improves the complexity of the matrix-vector product 

$$Ax = y$$

from $\mathcal{O}(N²)$ to $\mathcal{O}(N)$, where $A$ is the interaction matrix of points that evaluates the Green's function for a Laplace, Helmholtz or modified Helmholtz kernel. 

A common application is of the FMM is the Boundary Element Method (BEM). Further information concerning this topic can be found in the documentation.

## Installation 
The package can be installed by 

```@julia
import Pkg
Pkg.add("https://github.com/JoshuaTetzner/ExaFMMt.jl.git")
```
