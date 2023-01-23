using Exafmmt_jll

"""
    ModifiedHelmholtzFMM(wavek::Float64; ncrit=100, p=8)
    
Initializer for the modified-Helmholtz-FMM in the C++ part. 

# Arguments
- `wavek::Float64`: Wavenumber.
- `p::Int`: Multipole expansion order.
- `ncrit::Int`: Minimum number of points in each box of the tree.
"""
function ModifiedHelmholtzFMM(wavek::Float64; ncrit=100, p=8)

    return ccall(
        (:ModifiedHelmholtzFMM, libExafmm64),
        Ptr{Cvoid},
        (Cint, Cint, Float64),
        p,
        ncrit, 
        wavek
    )
end

"""
    ModifiedHelmholtzFMM(wavek::Float32; ncrit=100, p=8)
    
Initializer for the modified-Helmholtz-FMM in the C++ part. 

# Arguments
- `wavek::Float32`: Wavenumber.
- `p::Int`: Multipole expansion order.
- `ncrit::Int`: Minimum number of points in each box of the tree.
"""
function ModifiedHelmholtzFMM(wavek::Float32; ncrit=100, p=8)

    return ccall(
        (:ModifiedHelmholtzFMM, libExafmm32),
        Ptr{Cvoid},
        (Cint, Cint, Float32),
        p,
        ncrit, 
        wavek
    )
end

"""
    setup(
        sources::Matrix{F},
        targets::Matrix{F},
        fmmoptions::ModifiedHelmholtzFMMOptions{I, F}
    ) where {I, F <: Real}

Sets FMM structure up in the C++ part and allocates all madatory storage.

# Arguments
- `sources::Matrix{F}`: 3d-coordinates of sources.
- `targets::Matrix{F}`: 3d-coordinates of targets.
- `fmmoptions::ModifiedHelmholtzFMMOptions{I, F}`: Julia modified-Helmholtz-initializer for setup function.
"""
function setup(
    sources::Matrix{F},
    targets::Matrix{F},
    fmmoptions::ModifiedHelmholtzFMMOptions{I, F}
) where {I, F <: Real}

    src = init_sources(sources, zeros(F, size(sources)[1]))
    trg = init_targets(targets, F)
    fmm = ModifiedHelmholtzFMM(fmmoptions.wavek, ncrit=fmmoptions.ncrit, p=fmmoptions.p)
    fmmstruct = setup_modifiedhelmholtz(src, trg, fmm, fmmoptions)

    constructor = ExaFMM{F}(fmmoptions, size(sources)[1], size(targets)[1], fmm, fmmstruct, src, trg)
    Base.finalizer(freeF!, constructor)
    
    return constructor
end

function setup_modifiedhelmholtz(
    src::Ptr{Cvoid},
    trg::Ptr{Cvoid},
    fmm::Ptr{Cvoid},
    fmmoptions::ModifiedHelmholtzFMMOptions{I, Float64}
) where I

    return ccall(
        (:setup_modifiedhelmholtz, libExafmm64),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        src,
        trg,
        fmm
    )
end

function setup_modifiedhelmholtz(
    src::Ptr{Cvoid},
    trg::Ptr{Cvoid},
    fmm::Ptr{Cvoid},
    fmmoptions::ModifiedHelmholtzFMMOptions{I, Float32}
) where I

    return ccall(
        (:setup_modifiedhelmholtz, libExafmm32),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        src,
        trg,
        fmm
    )
end


"""
    evaluate(
        A::ExaFMM{F},
        x::Vector{F},
        fmmoptions::ModifiedHelmholtzFMMOptions{I, F}
    ) where {I, F <: Real}

Evaluates prebuild FMM structure `A` for new values `x`.

# Arguments
- `A::ExaFMM{F}`: ExaFMM structure with pointers to all allocated variables.
- `x::Vector{F}`: Values of for example the charge at each source location.
- `fmmoptions::ModifiedHelmholtzFMMOptions{I, F}`: Julia modified-Helmoltz-initializer for setup function, used as identifier.
"""
function evaluate(
    A::ExaFMM{F},
    x::Vector{F},
    fmmoptions::ModifiedHelmholtzFMMOptions{I, F}
) where {I, F <: Real}

    update_charges(A.fmmstruct, x)
    clear_values(A.fmmstruct, F)
    global exafmm32_64 = (F == Float32 ? libExafmm32 : libExafmm64)
    val = ccall(
        (:evaluate_modifiedhelmholtz, exafmm32_64),
        Ptr{F},
        (Ptr{Cvoid},),
        A.fmmstruct
    )
    eval = unsafe_wrap(Array, val, 4*A.ntargets, own=true)

    return reshape(eval, A.ntargets, 4)
end

function evaluate_modifiedhelmholtz(A::ExaFMM{Float64})
    return ccall(
        (:evaluate_modifiedhelmholtz, libExafmm64),
        Ptr{Float64},
        (Ptr{Cvoid},),
        A.fmmstruct
    )
end

function evaluate_modifiedhelmholtz(A::ExaFMM{Float32})
    return ccall(
        (:evaluate_modifiedhelmholtz, libExafmm32),
        Ptr{Float32},
        (Ptr{Cvoid},),
        A.fmmstruct
    )
end

"""
    verify(exafmm::ExaFMM{Float64}, fmmoptions::ModifiedHelmholtzFMMOptions{I, Float64})

Function compute accuracy of evaluated FMM `exafmm`.

# Arguments
- `exafmmm::ExaFMM{Float64}`: ExaFMM structure with pointers to all allocated variables.
- `fmmoptions::ModifiedHelmholtzFMMOptions{I, Float64}`: Julia modified-Helmholtz-initializer for setup function, used as identifier.
"""
function verify(
    exafmm::ExaFMM{Float64},
    fmmoptions::ModifiedHelmholtzFMMOptions{I, Float64}
) where I

    val = ccall(
        (:verify_modifiedhelmholtz, libExafmm64),
        Ptr{Float64},
        (Ptr{Cvoid},),
        exafmm.fmmstruct
    )

    return unsafe_wrap(Array, val, 2, own=true)
end

"""
    verify(exafmm::ExaFMM{Float32}, fmmoptions::ModifiedHelmholtzFMMOptions{I, Float32})

Function compute accuracy of evaluated FMM `exafmm`.

# Arguments
- `exafmmm::ExaFMM{Float32}`: ExaFMM structure with pointers to all allocated variables.
- `fmmoptions::ModifiedHelmholtzFMMOptions{I, Float32}`: Julia modified-Helmholtz-initializer for setup function, used as identifier.
"""
function verify(
    exafmm::ExaFMM{Float32},
    fmmoptions::ModifiedHelmholtzFMMOptions{I, Float32}
) where I

    val = ccall(
        (:verify_modifiedhelmholtz, libExafmm32),
        Ptr{Float32},
        (Ptr{Cvoid},),
        exafmm.fmmstruct
    )

    return unsafe_wrap(Array, val, 2, own=true)
end