# Functions and Types

# Types
```@docs
exafmm.HelmholtzFMMOptions{I, C}
ModifiedHelmholtzFMMOptions{I, F}
LaplaceFMMOptions{I}
ExaFMM{K}
```

# Functions 
```@docs
exafmm.init_sources(points::Matrix{F}, charges::Vector{F}) where F <: Real
exafmm.init_sources(points::Matrix{F}, charges::Vector{C}) where {F <: Real, C <: Complex}
exafmm.init_targets(points::Matrix{F}, ::Type) where F <: Real
exafmm.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{Float64})
exafmm.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{Float32})
exafmm.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{ComplexF64})
exafmm.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{ComplexF32})
exafmm.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{Float64})
exafmm.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{Float32})
exafmm.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{ComplexF64})
exafmm.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{ComplexF32})
exafmm.freeF!(x::ExaFMM{Float64})
exafmm.freeF!(x::ExaFMM{Float32})
exafmm.freeC!(x::ExaFMM{ComplexF64})
exafmm.freeC!(x::ExaFMM{ComplexF32})
```

### Laplace FMM
```@docs
exafmm.LaplaceFMM64(;ncrit=100, p=8)
exafmm.LaplaceFMM32(;ncrit=100, p=8)
exafmm.setup(sources::Matrix{F}, targets::Matrix{F}, fmmoptions::LaplaceFMMOptions{I}) where {I, F <: Real}
exafmm.evaluate(A::ExaFMM{F}, x::Vector{F}, fmmoptions::LaplaceFMMOptions{I}) where {I, F <: Real}
exafmm.verify(exafmm::ExaFMM{Float64}, fmmoptions::LaplaceFMMOptions{I}) where I
exafmm.verify(exafmm::ExaFMM{Float32}, fmmoptions::LaplaceFMMOptions{I}) where I
```

### Helmholtz FMM
```@docs
exafmm.HelmholtzFMM(wavek::ComplexF64; p=8, ncrit=100)
exafmm.HelmholtzFMM(wavek::ComplexF32; p=8, ncrit=100)
exafmm.setup(sources::Matrix{F}, targets::Matrix{F}, fmmoptions::HelmholtzFMMOptions{I, C}) where {I, F <: Real, C <: Complex}
exafmm.evaluate(A::ExaFMM{C}, x::Vector{C}, fmmoptions::HelmholtzFMMOptions{I, C}) where {I, C <: Complex}
exafmm.verify(exafmm::ExaFMM{ComplexF64}, fmmoptions::HelmholtzFMMOptions{I, ComplexF64}) where I
exafmm.verify(exafmm::ExaFMM{ComplexF32}, fmmoptions::HelmholtzFMMOptions{I, ComplexF32}) where I
```

### Modified-Helmholtz FMM
```@docs
exafmm.ModifiedHelmholtzFMM(wavek::Float64; ncrit=100, p=8)
exafmm.ModifiedHelmholtzFMM(wavek::Float32; ncrit=100, p=8)
setup(sources::Matrix{F}, targets::Matrix{F}, fmmoptions::ModifiedHelmholtzFMMOptions{I, F}) where {I, F <: Real}
exafmm.evaluate(A::ExaFMM{F}, x::Vector{F}, fmmoptions::ModifiedHelmholtzFMMOptions{I, F}) where {I, F <: Real} 
exafmm.verify(exafmm::ExaFMM{Float64}, fmmoptions::ModifiedHelmholtzFMMOptions{I, Float64}) where I
exafmm.verify(exafmm::ExaFMM{Float32}, fmmoptions::ModifiedHelmholtzFMMOptions{I, Float32}) where I
```