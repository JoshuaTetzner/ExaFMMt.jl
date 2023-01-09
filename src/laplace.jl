using exafmm_jll

"""
    LaplaceFMM64(;ncrit=100, p=8)
    
Initializer for the Laplace-FMM in the C++ part. 

# Arguments
- `p::Int`: Multipole expansion order.
- `ncrit::Int`: Minimum number of points in each box of the tree.
"""
function LaplaceFMM64(;ncrit=100, p=8)

    return ccall(
        (:LaplaceFMM, exafmmt),
        Ptr{Cvoid},
        (Cint, Cint),
        p,
        ncrit
    )
end

"""
    LaplaceFMM32(;ncrit=100, p=8)
    
Initializer for the Laplace-FMM in the C++ part.

# Arguments
- `p::Int`: Multipole expansion order.
- `ncrit::Int`: Minimum number of points in each box of the tree.
"""
function LaplaceFMM32(;ncrit=100, p=8)

    return ccall(
        (:LaplaceFMM, exafmmt32),
        Ptr{Cvoid},
        (Cint, Cint),
        p,
        ncrit
    )
end

"""
    setup(
        sources::Matrix{F},
        targets::Matrix{F}, 
        fmmoptions::LaplaceFMMOptions{I}
    ) where {I, F <: Real}

Sets FMM structure up in the C++ part and allocates all madatory storage.

# Arguments
- `sources::Matrix{F}`: 3d-coordinates of sources.
- `targets::Matrix{F}`: 3d-coordinates of targets.
- `fmmoptions::LaplaceFMMOptions{I}`: Julia Laplace-initializer for setup function.
"""
function setup(
    sources::Matrix{F},
    targets::Matrix{F},
    fmmoptions::LaplaceFMMOptions{I}
) where {I, F <: Real}

    src = init_sources(sources, zeros(F, size(sources)[1]))
    trg = init_targets(targets, F)
    #fmm = LaplaceFMM(F)
    fmm = (F == Float32 ? LaplaceFMM32() : LaplaceFMM64())
    fmmstruct = setup_laplace(src, trg, fmm, F)

    constructor = ExaFMM{F}(fmmoptions, size(sources)[1], size(targets)[1], fmm, fmmstruct, src, trg)
    Base.finalizer(freeF!, constructor)

    return constructor
end

function setup_laplace(
    src::Ptr{Cvoid},
    trg::Ptr{Cvoid},
    fmm::Ptr{Cvoid},
    F::Type{Float64}
)

    fmmstruct = ccall(
        (:setup_laplace, exafmmt),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        src,
        trg,
        fmm
    )
end

function setup_laplace(
    src::Ptr{Cvoid},
    trg::Ptr{Cvoid},
    fmm::Ptr{Cvoid},
    F::Type{Float32}
)

    fmmstruct = ccall(
        (:setup_laplace, exafmmt32),
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
        fmmoptions::LaplaceFMMOptions{I}
    ) where {I, F <: Real}

Evaluates prebuild FMM structure `A` for new values `x`.

# Arguments
- `A::ExaFMM{F}`: ExaFMM structure with pointers to all allocated variables.
- `x::Vector{F}`: Values of for example the charge at each source location.
- `fmmoptions::LaplaceFMMOptions{I}`: Julia Laplace-initializer for setup function, used as identifier.
"""
function evaluate(
    A::ExaFMM{F},
    x::Vector{F},
    fmmoptions::LaplaceFMMOptions{I}
) where {I, F <: Real}

    update_charges(A.fmmstruct, x)
    clear_values(A.fmmstruct, F)
    val = evaluate_laplace(A)
    eval = unsafe_wrap(Array, val, 4*A.ntargets, own=true)

    return reshape(eval, A.ntargets, 4)
end

function evaluate_laplace(
    A::ExaFMM{Float64}
)
    return ccall(
        (:evaluate_laplace, exafmmt),
        Ptr{Float64},
        (Ptr{Cvoid},),
        A.fmmstruct
    )
end

function evaluate_laplace(
    A::ExaFMM{Float32}
)
    return ccall(
        (:evaluate_laplace, exafmmt32),
        Ptr{Float32},
        (Ptr{Cvoid},),
        A.fmmstruct
    )
end

"""
    verify(exafmm::ExaFMM{Float64}, fmmoptions::LaplaceFMMOptions{I}) where I

Function compute accuracy of evaluated FMM `exafmm`.

# Arguments
- `exafmmm::ExaFMM{Float64}`: ExaFMM structure with pointers to all allocated variables.
- `fmmoptions::LaplaceFMMOptions{I}`: Julia Laplace-initializer for setup function, used as identifier.
"""
function verify(exafmm::ExaFMM{Float64}, fmmoptions::LaplaceFMMOptions{I}) where I

    val = ccall(
        (:verify_laplace, exafmmt),
        Ptr{Float64},
        (Ptr{Cvoid},),
        exafmm.fmmstruct
    )

    return unsafe_wrap(Array, val, 2, own=true)
end

"""
    verify(exafmm::ExaFMM{Float32}, fmmoptions::LaplaceFMMOptions{I}) where I

Function compute accuracy of evaluated FMM `exafmm`.

# Arguments
- `exafmmm::ExaFMM{Float32}`: ExaFMM structure with pointers to all allocated variables.
- `fmmoptions::LaplaceFMMOptions{I}`: Julia Laplace-initializer for setup function, used as identifier.
"""
function verify(exafmm::ExaFMM{Float32}, fmmoptions::LaplaceFMMOptions{I}) where I

    val = ccall(
        (:verify_laplace, exafmmt32),
        Ptr{Float32},
        (Ptr{Cvoid},),
        exafmm.fmmstruct
    )

    return unsafe_wrap(Array, val, 2, own=true)
end