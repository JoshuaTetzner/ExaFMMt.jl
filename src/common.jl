using exafmm_jll
using LinearAlgebra
using LinearMaps

abstract type FMMOptions end

struct HelmholtzFMMOptions{I, C} <: FMMOptions
    p::I
    ncrit::I
    wavek::C
end

function HelmholtzFMMOptions(wavek::C; p=8, ncrit=100) where C <: Complex
    return HelmholtzFMMOptions(p, ncrit, wavek)
end

struct ModifiedHelmholtzFMMOptions{I, F} <: FMMOptions
    p::I
    ncrit::I
    wavek::F
end

function ModifiedHelmholtzFMMOptions(wavek::F; p=8, ncrit=100) where F <: Real
    return ModifiedHelmholtzFMMOptions(p, ncrit, wavek)
end

struct LaplaceFMMOptions{I} <: FMMOptions
    p::I
    ncrit::I
end

function LapalceFMMOptions(;p=8, ncrit=100)
    return LaplaceFMMOptions(p, ncrit)
end

mutable struct ExaFMM
    fmmoptions::FMMOptions
    nsources
    ntargets
    fmm::Ptr{Cvoid}
    fmmstruct::Ptr{Cvoid}
    sources::Ptr{Cvoid}
    targets::Ptr{Cvoid}
end

function free(x::ExaFMM)
    if fmmoptions isa HelmholtzFMMOptions
        ccall(
            (:freestorage_cplx, exafmm_jll),
            Cvoid,
            (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
            x.fmm,
            x.fmmstruct,
            x.sources,
            x.targets
        )
    else
        ccall(
            (:freestorage_real, exafmm_jll),
            Cvoid,
            (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
            x.fmm,
            x.fmmstruct,
            x.sources,
            x.targets
        )
    end
end

function Base.size(fmm::ExaFMM, dim=nothing)
    if dim === nothing
        return (fmm.ntargets, fmat.nsources)
    elseif dim == 1
        return fmat.ntargets
    elseif dim == 2
        return fmat.nsources
    else
        error("dim must be either 1 or 2")
    end
end

function Base.size(fmm::Adjoint{T}, dim=nothing) where T <: ExaFMM
    if dim === nothing
        return reverse(size(adjoint(fmm)))
    elseif dim == 1
        return size(adjoint(fmm),2)
    elseif dim == 2
        return size(adjoint(fmm),1)
    else
        error("dim must be either 1 or 2")
    end
end

@views function LinearAlgebra.mul!(y::AbstractVecOrMat, A::ExaFMM, x::AbstractVector)
    LinearMaps.check_dim_mul(y, A, x)

    fill!(y, zero(eltype(y)))
    
    y = evaluate(A, x, A.fmmoptions) 

    return y
end


@views function LinearAlgebra.mul!(
    y::AbstractVecOrMat,
    transA::LinearMaps.TransposeMap{<:Any,<:ExaFMM},
    x::AbstractVector
)
    LinearMaps.check_dim_mul(y, transA, x)

    fill!(y, zero(eltype(y)))

    y = evaluate(A, x, A.fmmoptions) 

    return y
end

@views function LinearAlgebra.mul!(
    y::AbstractVecOrMat,
    transA::LinearMaps.AdjointMap{<:Any,<:ExaFMM},
    x::AbstractVector
)
    LinearMaps.check_dim_mul(y, transA, x)

    fill!(y, zero(eltype(y)))

    y = evaluate(A, x, A.fmmoptions) 

    return y
end

function init_sources(points::Matrix{F}, charges::Vector{F}) where F <: Real
    if size(points)[2] != 3
        throw("Only 3D distributions.")
    end
    if size(points)[1] != length(charges)
        throw("Charges and sources must be of same length.")
    end

    return ccall(
        (:init_sources_F, exafmmt),
        Ptr{Cvoid},
        (Ptr{F}, Ptr{F}, Cint),
        vec(points),
        charges,
        length(charges)
    )
end

function init_sources(points::Matrix{F}, charges::Vector{C}) where {F <: Real, C <: Complex}
    if size(points)[2] != 3
        throw("Only 3D distributions.")
    end
    if size(points)[1] != length(charges)
        throw("Charges and sources must be of same length.")
    end

    return ccall(
        (:init_sources_C, exafmmt),
        Ptr{Cvoid},
        (Ptr{F}, Ptr{C}, Cint),
        vec(points),
        charges,
        length(charges)
    )
end

a = rand(3, 3)
eltype(a)

function init_targets(points::Matrix{F}; T=F) where F <: Real
    
    if size(points)[2] != 3
        throw("Only 3D distributions.")
    end

    if T == eltype(points)
        return ccall(
            (:init_targets_F, exafmmt),
            Ptr{Cvoid},
            (Ptr{F}, Cint),
            vec(points),
            length(size(points[1]))
        )
    else
        return ccall(
            (:init_targets_C, exafmmt),
            Ptr{Cvoid},
            (Ptr{F}, Cint),
            vec(points),
            length(size(points[1]))
        )
    end
end

function update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{F}) where F <:Real

    ccall(
        (update_charges_real, exafmmt),
        Cvoid,
        (Ptr{Cvoid}, Ptr{F}),
        fmmstruct,
        charges
    )
end

function update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{C}) where C <: Complex

    ccall(
        (update_charges_cplx, exafmmt),
        Cvoid,
        (Ptr{Cvoid}, Ptr{C}),
        fmmstruct,
        charges
    )
end

function clear_values(fmmstruct::Ptr{Cvoid})

    ccall(
        (:clear_values, exafmmt),
        Cvoid,
        (Ptr{Cvoid},),
        fmmstruct
    )
end