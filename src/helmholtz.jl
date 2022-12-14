using exafmm_jll

function HelmholtzFMM(wavek::C; ncrit=100, p=8) where C <: Complex
    return ccall(
        (:HelmholtzFMM, exafmmt),
        Ptr{Cvoid},
        (Cint, Cint, ComplexF32),
        p,
        ncrit,
        wavek
    )
end

function setup(
    sources::Matrix{F},
    targets::Matrix{F},
    fmmoptions::HelmholtzFMMOptions{I, C}
) where {I, F <: Real, C <: Complex}

    src = init_sources(sources, zeros(C, size(sources)[1]))
    trg = init_targets(targets, T=C)
    fmm = HelmholtzFMM(fmmoptions.wavek, ncrit=fmmoptions.ncrit, p=fmmoptions.p)
    fmmstruct = ccall(
        (:setup_helmholtz, exafmmt),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        src,
        trg,
        fmm
    )

    constructor = ExaFMM{C}(fmmoptions, size(sources)[1], size(targets)[1], fmm, fmmstruct, src, trg)
    Base.finalizer(freeC!, constructor)

    return constructor
end

function evaluate(
    A::ExaFMM,
    x::Vector{C},
    fmmoptions::HelmholtzFMMOptions{I, C};
    verify=false
) where {I, C <: Complex}

    update_charges(A.fmmstruct, x)
    clear_values(A.fmmstruct)
    val = ccall(
        (:evaluate_helmholtz, exafmmt),
        Ptr{C},
        (Ptr{Cvoid},),
        A.fmmstruct
    )
    eval = unsafe_wrap(Array, val, 4*A.ntargets, own=true)
    
    return reshape(eval, A.ntargets, 4)
end

function verify(
    exaf::ExaFMM,
    fmmoptions::HelmholtzFMMOptions{I, C}
) where {I, C <: Complex} 

    val = ccall(
        (:verify_helmholtz, exafmmt),
        Ptr{C},
        (Ptr{Cvoid},),
        A.fmmstruct
    )

    return unsafe_wrap(Array, val, 2, own=true)
end