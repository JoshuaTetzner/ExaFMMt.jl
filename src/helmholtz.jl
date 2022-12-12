using exafmm_jll

function HelmholtzFMM(ncrit, p, wavek)
    return ccall(
        (:HelmholtzFMM, exafmmt),
        Ptr{Cvoid},
        (Cint, Cint, ComplexF64),
        ncrit,
        p,
        wavek
    )
end

function setup_helmholtz(sources::Ptr{Cvoid}, targets::Ptr{Cvoid}, fmm::Ptr{Cvoid})

    return ccall(
        (:setup_helmholtz, exafmmt),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        sources,
        targets,
        fmm
    )
end

function evaluate_helmholtz(constructor::Ptr{Cvoid}, n)
    val = ccall(
        (:evaluate_helmholtz, exafmmt),
        Ptr{ComplexF64},
        (Ptr{Cvoid},),
        constructor
    )
    eval = unsafe_wrap(Array, val, own=true)

    return reshape(eval, n, 4)
end

