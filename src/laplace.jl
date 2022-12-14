using exafmm_jll

function LaplaceFMM(;ncrit=100, p=8)
    return ccall(
        (:LaplaceFMM, exafmmt),
        Ptr{Cvoid},
        (Cint, Cint),
        p,
        ncrit
    )
end

function setup(
    sources::Matrix{F},
    targets::Matrix{F},
    fmmoptions::LaplaceFMMOptions{I}
) where {I, F <: Real}

    src = init_sources(sources, zeros(F, size(sources)[1]))
    trg = init_targets(targets)
    fmm = LaplaceFMM()
    fmmstruct = ccall(
        (:setup_laplace, exafmmt),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        src,
        trg,
        fmm
    )

    constructor = ExaFMM{F}(fmmoptions, size(sources)[1], size(targets)[1], fmm, fmmstruct, src, trg)
    Base.finalizer(freeF!, constructor)

    return constructor
end

function evaluate(
    A::ExaFMM,
    x::Vector{F},
    fmmoptions::LaplaceFMMOptions{I}
) where {I, F <: Real}

    update_charges(A.fmmstruct, x)
    clear_values(A.fmmstruct)
    val = ccall(
        (:evaluate_laplace, exafmmt),
        Ptr{F},
        (Ptr{Cvoid},),
        A.fmmstruct
    )
    eval = unsafe_wrap(Array, val, 4*A.ntargets, own=true)

    return reshape(eval, A.ntargets, 4)
end

function verify(
    exaf::ExaFMM,
    fmmoptions::LaplaceFMMOptions{I}
) where {I} 

    val = ccall(
        (:verify_laplace, exafmmt),
        Ptr{Cdouble},
        (Ptr{Cvoid},),
        A.fmmstruct
    )

    return unsafe_wrap(Array, val, 2, own=true)
end