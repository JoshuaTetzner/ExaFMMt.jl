using exafmm_jll

function ModifiedHelmholtzFMM(wavek::Float64; ncrit=100, p=8)

    return ccall(
        (:ModifiedHelmholtzFMM, exafmmt),
        Ptr{Cvoid},
        (Cint, Cint, Cdouble),
        ncrit,
        p, 
        wavek
    )
end

function setup(
    sources::Matrix{F},
    targets::Vector{F},
    fmmoptions::ModifiedHelmholtzFMMOptions{I, F}
) where {I, F <: Real}

    src = init_sources(sources, zeros(F, size(sources)[1]))
    trg = init_targets(targets)
    fmm = ModifiedHelmholtzFMM(wavek, ncrit=fmmoptions.ncrit, p=fmmoptions.p)
    fmmstruct = ccall(
        (:setup_modifiedhelmholtz, exafmmt),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        src,
        trg,
        fmm
    )

    constructor = ExaFMM(fmmoptions, size(sources)[1], size(targets)[1], fmm, fmmstruct, src, trg)
    Base.finalizer(constructor, free(constructor))
    
    return constructor
end

function evaluate(
    A::ExaFMM,
    x::Vector{F},
    fmmoptions::ModifiedHelmholtzFMMOptions{I, F}
) where {I, F <: Real}

    update_charges(A.fmmstruct, x)
    clear_values(A.fmmstruct)
    val = ccall(
        (:evaluate_modifiedhelmholtz, exafmmt),
        Ptr{F},
        (Ptr{Cvoid},),
        A.fmmstruct
    )
    eval = unsafe_wrap(Array, val, 4*A.ntargets, own=true)

    return reshape(eval, A.ntargets, 4)
end