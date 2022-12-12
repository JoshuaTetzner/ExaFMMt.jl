using exafmm_jll

function ModifiedHelmholtzFMM(ncrit, p)

    return ccall(
        (:ModifiedHelmholtzFMM, exafmmt),
        Ptr{Cvoid},
        (Cint, Cint, Cdouble),
        ncrit,
        p, 
        wavek
    )
end

function setup_modifiedhelmholtz(sources::Ptr{Cvoid}, targets::Ptr{Cvoid}, fmm::Ptr{Cvoid})

    return ccall(
        (:setup_modifiedhelmholtz, exafmmt),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        sources,
        targets,
        fmm
    )
end

function evaluate_modifiedhelmholtz(constructor::Ptr{Cvoid})

    val = ccall(
        (:evaluate_modifiedhelmholtz, exafmmt),
        Ptr{Cdouble},
        (Ptr{Cvoid},),
        constructor
    )
    eval = unsafe_wrap(Array, val, own=true)

    return reshape(eval, n, 4)
end