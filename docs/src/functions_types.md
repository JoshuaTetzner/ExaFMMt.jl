# Functions and Types

# Types
```@docs
ExaFMMt.HelmholtzFMMOptions{I, C}
ExaFMMt.ModifiedHelmholtzFMMOptions{I, F}
ExaFMMt.LaplaceFMMOptions{I}
ExaFMMt.ExaFMM{K}
```

# Functions 
```@docs
ExaFMMt.init_sources(points::Matrix{F}, charges::Vector{F}) where F <: Real
ExaFMMt.init_sources(points::Matrix{F}, charges::Vector{C}) where {F <: Real, C <: Complex}
ExaFMMt.init_targets(points::Matrix{F}, ::Type) where F <: Real
ExaFMMt.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{Float64})
ExaFMMt.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{Float32})
ExaFMMt.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{ComplexF64})
ExaFMMt.update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{ComplexF32})
ExaFMMt.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{Float64})
ExaFMMt.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{Float32})
ExaFMMt.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{ComplexF64})
ExaFMMt.clear_values(fmmstruct::Ptr{Cvoid}, T::Type{ComplexF32})
ExaFMMt.freeF!(x::ExaFMMt.ExaFMM{Float64})
ExaFMMt.freeF!(x::ExaFMMt.ExaFMM{Float32})
ExaFMMt.freeC!(x::ExaFMMt.ExaFMM{ComplexF64})
ExaFMMt.freeC!(x::ExaFMMt.ExaFMM{ComplexF32})
```

### Laplace FMM
```@docs
ExaFMMt.LaplaceFMM64(;ncrit=100, p=8)
ExaFMMt.LaplaceFMM32(;ncrit=100, p=8)
ExaFMMt.setup(sources::Matrix{F}, targets::Matrix{F}, fmmoptions::ExaFMMt.LaplaceFMMOptions{I}) where {I, F <: Real}
ExaFMMt.evaluate(A::ExaFMMt.ExaFMM{F}, x::Vector{F}, fmmoptions::ExaFMMt.LaplaceFMMOptions{I}) where {I, F <: Real}
ExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{Float64}, fmmoptions::ExaFMMt.LaplaceFMMOptions{I}) where I
ExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{Float32}, fmmoptions::ExaFMMt.LaplaceFMMOptions{I}) where I
```

### Helmholtz FMM
```@docs
ExaFMMt.HelmholtzFMM(wavek::ComplexF64; p=8, ncrit=100)
ExaFMMt.HelmholtzFMM(wavek::ComplexF32; p=8, ncrit=100)
ExaFMMt.setup(sources::Matrix{F}, targets::Matrix{F}, fmmoptions::ExaFMMt.HelmholtzFMMOptions{I, C}) where {I, F <: Real, C <: Complex}
ExaFMMt.evaluate(A::ExaFMMt.ExaFMM{C}, x::Vector{C}, fmmoptions::ExaFMMt.HelmholtzFMMOptions{I, C}) where {I, C <: Complex}
ExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{ComplexF64}, fmmoptions::ExaFMMt.HelmholtzFMMOptions{I, ComplexF64}) where I
ExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{ComplexF32}, fmmoptions::ExaFMMt.HelmholtzFMMOptions{I, ComplexF32}) where I
```

### Modified-Helmholtz FMM
```@docs
ExaFMMt.ModifiedHelmholtzFMM(wavek::Float64; ncrit=100, p=8)
ExaFMMt.ModifiedHelmholtzFMM(wavek::Float32; ncrit=100, p=8)
ExaFMMt.setup(sources::Matrix{F}, targets::Matrix{F}, fmmoptions::ExaFMMt.ModifiedHelmholtzFMMOptions{I, F}) where {I, F <: Real}
ExaFMMt.evaluate(A::ExaFMMt.ExaFMM{F}, x::Vector{F}, fmmoptions::ExaFMMt.ModifiedHelmholtzFMMOptions{I, F}) where {I, F <: Real} 
ExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{Float64}, fmmoptions::ExaFMMt.ModifiedHelmholtzFMMOptions{I, Float64}) where I
ExaFMMt.verify(exafmm::ExaFMMt.ExaFMM{Float32}, fmmoptions::ExaFMMt.ModifiedHelmholtzFMMOptions{I, Float32}) where I
```