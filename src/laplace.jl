using exafmm_jll

function LaplaceFMM(ncrit, p)

    return ccall(
        (:LaplaceFMM, exafmmt),
        Ptr{Cvoid},
        (Cint, Cint),
        ncrit,
        p
    )
end

function setup_laplace(sources::Ptr{Cvoid}, targets::Ptr{Cvoid}, fmm::Ptr{Cvoid})

    return ccall(
        (:setup_laplace, exafmmt),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
        sources,
        targets,
        fmm
    )
end

function evaluate_laplace(constructor::Ptr{Cvoid}, n)

    val = ccall(
        (:evaluate_laplace, exafmmt),
        Ptr{Cdouble},
        (Ptr{Cvoid},),
        constructor
    )
    eval = unsafe_wrap(Array, val, own=true)

    return reshape(eval, n, 4)
end