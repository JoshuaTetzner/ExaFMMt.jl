using Exafmmt_jll

"""
    LaplaceFMM64(;ncrit=100, p=8)

Initializer for the Laplace-FMM in the C++ part.

# Arguments

  - `p::Int`: Multipole expansion order.
  - `ncrit::Int`: Minimum number of points in each box of the tree.
"""
function LaplaceFMM64(; ncrit=100, p=8)
    return ccall((:LaplaceFMM, libExafmm64), Ptr{Cvoid}, (Cint, Cint), p, ncrit)
end

"""
    LaplaceFMM32(;ncrit=100, p=8)

Initializer for the Laplace-FMM in the C++ part.

# Arguments

  - `p::Int`: Multipole expansion order.
  - `ncrit::Int`: Minimum number of points in each box of the tree.
"""
function LaplaceFMM32(; ncrit=100, p=8)
    return ccall((:LaplaceFMM, libExafmm32), Ptr{Cvoid}, (Cint, Cint), p, ncrit)
end

"""
    setup(
        sources::Matrix{F},
        targets::Matrix{F}, 
        fmmoptions::LaplaceFMMOptions{I}
    ) where {I, F <: Real}

Sets the FMM structure up in the C++ part and allocates all mandatory storage.

# Arguments

  - `sources::Matrix{F}`: 3d-coordinates of sources.
  - `targets::Matrix{F}`: 3d-coordinates of targets.
  - `fmmoptions::LaplaceFMMOptions{I}`: Julia Laplace-initializer for setup function.
"""
function setup(
    sources::Matrix{F}, targets::Matrix{F}, fmmoptions::LaplaceFMMOptions{I}
) where {I,F<:Real}
    validate_setup_inputs(sources, targets, fmmoptions)

    src = init_sources(sources, zeros(F, size(sources, 1)))
    trg = init_targets(targets, F)
    fmm = (
        if F == Float32
            LaplaceFMM32(; ncrit=fmmoptions.ncrit, p=fmmoptions.p)
        else
            LaplaceFMM64(; ncrit=fmmoptions.ncrit, p=fmmoptions.p)
        end
    )
    fmmstruct = setup_laplace(src, trg, fmm, F)

    constructor = ExaFMM{F}(
        fmmoptions, size(sources, 1), size(targets, 1), fmm, fmmstruct, src, trg
    )

    return constructor
end

function setup_laplace(src::Ptr{Cvoid}, trg::Ptr{Cvoid}, fmm::Ptr{Cvoid}, F::Type{Float64})
    return fmmstruct = ccall(
        (:setup_laplace, libExafmm64),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        src,
        trg,
        fmm,
    )
end

function setup_laplace(src::Ptr{Cvoid}, trg::Ptr{Cvoid}, fmm::Ptr{Cvoid}, F::Type{Float32})
    return fmmstruct = ccall(
        (:setup_laplace, libExafmm32),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        src,
        trg,
        fmm,
    )
end

"""
    evaluate(
        A::ExaFMM{F},
        x::Vector{F},
        fmmoptions::LaplaceFMMOptions{I}
    ) where {I, F <: Real}

Evaluates the prebuilt FMM structure `A` for new values `x`.

# Arguments

  - `A::ExaFMM{F}`: ExaFMM structure with pointers to all allocated variables.
  - `x::Vector{F}`: Values of for example the charge at each source location.
  - `fmmoptions::LaplaceFMMOptions{I}`: Julia Laplace-initializer for setup function, used as identifier.
"""
function evaluate(
    A::ExaFMM{F}, x::Vector{F}, fmmoptions::LaplaceFMMOptions{I}
) where {I,F<:Real}
    check_open(A)
    validate_charges(A, x)
    update_charges(A.fmmstruct, x)
    clear_values(A.fmmstruct, F)
    val = evaluate_laplace(A)
    eval = wrap_c_result(val, 4*A.ntargets)

    return reshape(eval, A.ntargets, 4)
end

function evaluate_laplace(A::ExaFMM{Float64})
    return ccall((:evaluate_laplace, libExafmm64), Ptr{Float64}, (Ptr{Cvoid},), A.fmmstruct)
end

function evaluate_laplace(A::ExaFMM{Float32})
    return ccall((:evaluate_laplace, libExafmm32), Ptr{Float32}, (Ptr{Cvoid},), A.fmmstruct)
end

"""
    verify(exafmm::ExaFMM{Float64}, fmmoptions::LaplaceFMMOptions{I}) where I

Computes the accuracy of the evaluated FMM `exafmm`.

# Arguments

  - `exafmm::ExaFMM{Float64}`: ExaFMM structure with pointers to all allocated variables.
  - `fmmoptions::LaplaceFMMOptions{I}`: Julia Laplace-initializer for setup function, used as identifier.
"""
function verify(exafmm::ExaFMM{Float64}, fmmoptions::LaplaceFMMOptions{I}) where {I}
    check_open(exafmm)
    val = ccall(
        (:verify_laplace, libExafmm64), Ptr{Float64}, (Ptr{Cvoid},), exafmm.fmmstruct
    )

    return wrap_c_result(val, 2)
end

"""
    verify(exafmm::ExaFMM{Float32}, fmmoptions::LaplaceFMMOptions{I}) where I

Computes the accuracy of the evaluated FMM `exafmm`.

# Arguments

  - `exafmm::ExaFMM{Float32}`: ExaFMM structure with pointers to all allocated variables.
  - `fmmoptions::LaplaceFMMOptions{I}`: Julia Laplace-initializer for setup function, used as identifier.
"""
function verify(exafmm::ExaFMM{Float32}, fmmoptions::LaplaceFMMOptions{I}) where {I}
    check_open(exafmm)
    val = ccall(
        (:verify_laplace, libExafmm32), Ptr{Float32}, (Ptr{Cvoid},), exafmm.fmmstruct
    )

    return wrap_c_result(val, 2)
end
