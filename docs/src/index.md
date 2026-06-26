# ExaFMMt

This package wraps the [exafmm-t](https://github.com/exafmm/exafmm-t) library for Julia.
Since Julia cannot natively call C++ functions, a C interface was added to [exafmm-t](https://github.com/exafmm/exafmm-t) in the fork at [JoshuaTetzner/exafmm-t](https://github.com/JoshuaTetzner/exafmm-t/tree/feature/c_interface). The binary is built and published via [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil) and registered as [Exafmmt_jll](https://github.com/JuliaBinaryWrappers/Exafmmt_jll.jl) in [JuliaBinaryWrappers](https://github.com/JuliaBinaryWrappers/).

The Fast Multipole Method (FMM) reduces the complexity of the matrix-vector product of an interaction matrix evaluating the Green's function for a Laplace, Helmholtz, or modified Helmholtz kernel from $\mathcal{O}(N^2)$ to $\mathcal{O}(N)$. For the algorithmic background see [Fast Multipole Method](./details/fmm.md), and for its use within the Boundary Element Method see [FMM with the BEM](@ref FMM_BEM).

Since [exafmm-t](https://github.com/exafmm/exafmm-t) uses Unix-only functions, a Windows build is not available. Recommendations on how to get Windows builds working are always welcome. Please open an issue on this repository.

!!! note
    The current JLL build expects a BLAS/LAPACK backend to be loaded through Julia's BLAS stack. If your session has no backend configured, load one such as `MKL` before using `ExaFMMt`.

## Installation
The package can be installed by entering the package manager (enter `]` at the julia REPL) and issuing:

```
pkg> add https://github.com/JoshuaTetzner/ExaFMMt.jl.git
```

## [References](@id refs)
- [1] Wang, Tingyu, Christopher D. Cooper, Timo Betcke, and Lorena A. Barba. *High-Productivity, High-Performance Workflow for Virus-Scale Electrostatic Simulations with Bempp-Exafmm.* arXiv, March 20, 2021. [http://arxiv.org/abs/2103.01048](http://arxiv.org/abs/2103.01048).
- [2] Adelman, Ross, Nail A. Gumerov, and Ramani Duraiswami. *FMM/GPU-Accelerated Boundary Element Method for Computational Magnetics and Electrostatics.* IEEE Transactions on Magnetics 53, no. 12 (December 2017): 1–11. [https://doi.org/10.1109/TMAG.2017.2725951](https://doi.org/10.1109/TMAG.2017.2725951).
