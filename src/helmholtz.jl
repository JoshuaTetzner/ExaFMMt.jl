using Exafmmt_jll


"""
    HelmholtzFMM(wavek::ComplexF64; p=8, ncrit=100)
    
Initializer for the Helmholtz-FMM in the C++ part. 

# Arguments
- `wavek::ComplexF64`: Wavenumber.
- `p::Int`: Multipole expansion order.
- `ncrit::Int`: Minimum number of points in each box of the tree.
"""
function HelmholtzFMM(wavek::ComplexF64; ncrit=100, p=8)

    return ccall(
        (:HelmholtzFMM, libExafmm64),
        Ptr{Cvoid},
        (Cint, Cint, ComplexF64),
        p,
        ncrit,
        wavek
    )
end

"""
    HelmholtzFMM(wavek::ComplexF32; p=8, ncrit=100)
    
Initializer for the Helmholtz-FMM in the C++ part. 

# Arguments
- `wavek::ComplexF32`: Wavenumber.
- `p::Int`: Multipole expansion order.
- `ncrit::Int`: Minimum number of points in each box of the tree.
"""
function HelmholtzFMM(wavek::ComplexF32; ncrit=100, p=8)

    return ccall(
        (:HelmholtzFMM, libExafmm32),
        Ptr{Cvoid},
        (Cint, Cint, ComplexF32),
        p,
        ncrit,
        wavek
    )
end

"""
    setup(
        sources::Matrix{F},
        targets::Matrix{F},
        fmmoptions::HelmholtzFMMOptions{I, C}
    ) where {I, F <: Real, C <: Complex}

Sets FMM structure up in the C++ part and allocates all madatory storage.

# Arguments
- `sources::Matrix{F}`: 3d-coordinates of sources.
- `targets::Matrix{F}`: 3d-coordinates of targets.
- `fmmoptions::HelmholtzFMMOptions{I, C}`: Julia Helmoltz-initializer for setup function.
"""
function setup(
    sources::Matrix{F},
    targets::Matrix{F},
    fmmoptions::HelmholtzFMMOptions{I, C}
) where {I, F <: Real, C <: Complex}

    src = init_sources(sources, zeros(C, size(sources)[1]))
    trg = init_targets(targets, C)
    fmm = HelmholtzFMM(fmmoptions.wavek, ncrit=fmmoptions.ncrit, p=fmmoptions.p)
    fmmstruct = setup_helmholtz(src, trg, fmm, fmmoptions)
    
    constructor = ExaFMM{C}(fmmoptions, size(sources)[1], size(targets)[1], fmm, fmmstruct, src, trg)
    Base.finalizer(freeC!, constructor)

    return constructor
end

function setup_helmholtz(
    src::Ptr{Cvoid},
    trg::Ptr{Cvoid},
    fmm::Ptr{Cvoid},
    fmmoptions::HelmholtzFMMOptions{I, ComplexF64}
) where I

    return ccall(
        (:setup_helmholtz, libExafmm64),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        src,
        trg,
        fmm
    )
end

function setup_helmholtz(
    src::Ptr{Cvoid},
    trg::Ptr{Cvoid},
    fmm::Ptr{Cvoid},
    fmmoptions::HelmholtzFMMOptions{I, ComplexF32}
) where I

    return ccall(
        (:setup_helmholtz, libExafmm32),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        src,
        trg,
        fmm
    )
end

"""
    evaluate(
        A::ExaFMM{C},
        x::Vector{C},
        fmmoptions::HelmholtzFMMOptions{I, C}
    ) where {I, C <: Complex}

Evaluates prebuild FMM structure `A` for new values `x`.

# Arguments
- `A::ExaFMM{C}`: ExaFMM structure with pointers to all allocated variables.
- `x::Vector{C}`: Values of for example the charge at each source location.
- `fmmoptions::HelmholtzFMMOptions{I, C}`: Julia Helmoltz-initializer for setup function, used as identifier.
"""
function evaluate(
    A::ExaFMM{C},
    x::Vector{C},
    fmmoptions::HelmholtzFMMOptions{I, C}
) where {I, C <: Complex}

    update_charges(A.fmmstruct, x)
    clear_values(A.fmmstruct, C)

    val = evaluate_helmholtz(A)
    eval = unsafe_wrap(Array, val, 4*A.ntargets, own=true)
    
    return reshape(eval, A.ntargets, 4)
end

function evaluate_helmholtz(A::ExaFMM{ComplexF64})

    return ccall(
        (:evaluate_helmholtz, libExafmm64),
        Ptr{ComplexF64},
        (Ptr{Cvoid},),
        A.fmmstruct
    )
end

function evaluate_helmholtz(A::ExaFMM{ComplexF32})

    return ccall(
        (:evaluate_helmholtz, libExafmm32),
        Ptr{ComplexF32},
        (Ptr{Cvoid},),
        A.fmmstruct
    )
end

"""
    verify(exafmm::ExaFMM{ComplexF64}, fmmoptions::HelmholtzFMMOptions{I, ComplexF64}) where I

Function compute accuracy of evaluated FMM `exafmm`.

# Arguments
- `exafmmm::ExaFMM`: ExaFMM structure with pointers to all allocated variables.
- `fmmoptions::HelmholtzFMMOptions{I, ComplexF64}`: Julia Helmoltz-initializer for setup function, used as identifier.
"""
function verify(exafmm::ExaFMM{ComplexF64}, fmmoptions::HelmholtzFMMOptions{I, ComplexF64}) where I

    val = ccall(
        (:verify_helmholtz, libExafmm64),
        Ptr{ComplexF64},
        (Ptr{Cvoid},),
        exafmm.fmmstruct
    )
    return unsafe_wrap(Array, val, 2, own=true)
end

"""
    verify(exafmm::ExaFMM{ComplexF32}, fmmoptions::HelmholtzFMMOptions{I, ComplexF32}) where I

Function compute accuracy of evaluated FMM `exafmm`.

# Arguments
- `exafmmm::ExaFMM`: ExaFMM structure with pointers to all allocated variables.
- `fmmoptions::HelmholtzFMMOptions{I, ComplexF32}`: Julia Helmoltz-initializer for setup function, used as identifier.
"""
function verify(exafmm::ExaFMM{ComplexF32}, fmmoptions::HelmholtzFMMOptions{I, ComplexF32}) where I

    val = ccall(
        (:verify_helmholtz, libExafmm32),
        Ptr{ComplexF32},
        (Ptr{Cvoid},),
        exafmm.fmmstruct
    )
    return unsafe_wrap(Array, val, 2, own=true)
end