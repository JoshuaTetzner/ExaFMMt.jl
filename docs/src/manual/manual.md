# General Usage

This page shows how to set up and evaluate an FMM matrix with ExaFMMt in
practice. The workflow is the same for the Laplace, Helmholtz, and modified
Helmholtz kernels: build an options object, `setup` the matrix, and apply it to a
charge vector.

## First Steps

A simple Laplace FMM of a random distribution of charges is computed by the
following code:

```julia
using MKL # or another BLAS/LAPACK backend configured for your Julia session
using ExaFMMt

sources = rand(Float64, 120, 3)
targets = rand(Float64, 80, 3)
charges = rand(Float64, 120)

A = setup(sources, targets, LaplaceFMMOptions())
y = A * charges
```

The variable `A` represents the FMM matrix and can be multiplied by a vector of
`Float64` charges with one entry per source. The result `y` contains the
potential at each target.

## Choosing the Kernel

The kernel is selected through the options object passed to [`setup`](@ref):

```julia
# Laplace
A = setup(sources, targets, LaplaceFMMOptions())

# Helmholtz with a complex wavenumber
A = setup(sources, targets, HelmholtzFMMOptions(ComplexF64(1.0 + 1.0im)))

# Modified Helmholtz with a real wavenumber
A = setup(sources, targets, ModifiedHelmholtzFMMOptions(Float64(1.0)))
```

Each options constructor accepts the expansion order `p` and the leaf-size
parameter `ncrit`, e.g. `LaplaceFMMOptions(; ncrit=100, p=8)`.

## Precision

The FMM uses 64-bit arithmetic when the inputs are `Float64` or `ComplexF64`. If
all coordinates, charges, and kernel values are provided as `Float32` or
`ComplexF32`, the 32-bit library is used instead. Mixing 32-bit and 64-bit
inputs is rejected.

## Gradients

Use `evaluate(A, charges, A.fmmoptions)` if you also need the three gradient
columns returned by the C++ library in addition to the potential.

For complete, runnable code per kernel see the [Application Examples](./examples.md).
