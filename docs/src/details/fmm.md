# Fast Multipole Method

## Introduction

The Fast Multipole Method (FMM) improves the complexity of the matrix-vector product

$$Ax = y$$

from $\mathcal{O}(N^2)$ to $\mathcal{O}(N)$, where $A$ is the interaction matrix of points that evaluates the Green's function for a Laplace, Helmholtz, or modified Helmholtz kernel.

A common application of the FMM is the Boundary Element Method (BEM). Further information concerning this topic can be found in [FMM with the BEM](@ref FMM_BEM).

## Backend

ExaFMMt wraps the [exafmm-t](https://github.com/exafmm/exafmm-t) library through the [Exafmmt_jll](https://github.com/JuliaBinaryWrappers/Exafmmt_jll.jl) binary.

The current JLL build expects a BLAS/LAPACK backend to be loaded through Julia's BLAS stack. If your session has no backend configured, load one such as `MKL` before using `ExaFMMt`.
