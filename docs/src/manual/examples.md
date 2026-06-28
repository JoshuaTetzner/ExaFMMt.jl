# Application Examples

This section contains end-to-end examples for each supported kernel.

The FMM uses 64-bit arithmetic when the inputs are `Float64` or `ComplexF64`. If all coordinates, charges, and kernel values are provided as `Float32` or `ComplexF32`, it uses the 32-bit library. Mixing 32-bit and 64-bit inputs is rejected.

## Laplace FMM
```@example laplace
using MKL # or another BLAS/LAPACK backend configured for your Julia session
using ExaFMMt

# 64 bit representation
nsources = 10000
ntargets = 8000
sources = rand(Float64, nsources, 3)
targets = rand(Float64, ntargets, 3)
charges = rand(Float64, nsources)

A = setup(sources, targets, LaplaceFMMOptions())
y = A * charges

# 32 bit representation
sources = rand(Float32, nsources, 3)
targets = rand(Float32, ntargets, 3)
charges = rand(Float32, nsources)

A = setup(sources, targets, LaplaceFMMOptions())
y = A * charges
y[1:5]
```

## Helmholtz FMM
```@example helmholtz
using MKL # or another BLAS/LAPACK backend configured for your Julia session
using ExaFMMt

# 64 bit representation
nsources = 10000
ntargets = 8000
sources = rand(Float64, nsources, 3)
targets = rand(Float64, ntargets, 3)
charges = rand(ComplexF64, nsources)
wavek = ComplexF64.(1.0 + 1.0*im)

A = setup(sources, targets, HelmholtzFMMOptions(wavek))
y = A * charges

# 32 bit representation
sources = rand(Float32, nsources, 3)
targets = rand(Float32, ntargets, 3)
charges = rand(ComplexF32, nsources)
wavek = ComplexF32.(1.0 + 1.0*im)

A = setup(sources, targets, HelmholtzFMMOptions(wavek))
y = A * charges
y[1:5]
```

## Modified-Helmholtz FMM
```@example modifiedhelmholtz
using MKL # or another BLAS/LAPACK backend configured for your Julia session
using ExaFMMt

# 64 bit representation
nsources = 10000
ntargets = 8000
sources = rand(Float64, nsources, 3)
targets = rand(Float64, ntargets, 3)
charges = rand(Float64, nsources)
wavek = Float64(1.0)

A = setup(sources, targets, ModifiedHelmholtzFMMOptions(wavek))
y = A * charges

# 32 bit representation
sources = rand(Float32, nsources, 3)
targets = rand(Float32, ntargets, 3)
charges = rand(Float32, nsources)
wavek = Float32(1.0)

A = setup(sources, targets, ModifiedHelmholtzFMMOptions(wavek))
y = A * charges
y[1:5]
```
