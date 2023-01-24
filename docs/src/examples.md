# Examples
The FMM evaluates per default in 64 bits representation. If the input values are all given in 32 bit representation the code changes to 32 bit calculations. Errors may occur if 32 and 64 bit representations are mixed.

## Laplace FMM
```julia
using ExaFMMt

# 64 bit representation
n = 10000
sources = rand(Float64, n, 3)
targets = rand(Float64, n, 3)
charges = rand(Float64, n)

A = setup(sources, targets, LaplaceFMMOptions())
y = A * charges

# 32 bit representation
sources = rand(Float32, n, 3)
targets = rand(Float32, n, 3)
charges = rand(Float32, n)

A = setup(sources, targets, LaplaceFMMOptions())
y = A * charges
```

## Helmholtz FMM
```julia
using ExaFMMt

# 64 bit representation
n = 10000
sources = rand(Float64, n, 3)
targets = rand(Float64, n, 3)
charges = rand(ComplexF64, n)
wavek = ComplexF64.(1.0 + 1.0*im)

A = setup(sources, targets, HelmholtzFMMOptions(wavek))
y = A * charges

# 32 bit representation
sources = rand(Float32, n, 3)
targets = rand(Float32, n, 3)
charges = rand(ComplexF32, n)
wavek = ComplexF32.(1.0 + 1.0*im)

A = setup(sources, targets, HelmholtzFMMOptions(wavek))
y = A * charges
```

## Modified-Helmholtz FMM
```julia
using ExaFMMt

# 64 bit representation
n = 10000
sources = rand(Float64, n, 3)
targets = rand(Float64, n, 3)
charges = rand(Float64, n)
wavek = Float64(1.0)

A = setup(sources, targets, ModifiedHelmholtzFMMOptions(wavek))
y = A * charges

# 32 bit representation
sources = rand(Float32, n, 3)
targets = rand(Float32, n, 3)
charges = rand(Float32, n)
wavek = Float32(1.0)

A = setup(sources, targets, ModifiedHelmholtzFMMOptions(wavek))
y = A * charges
```