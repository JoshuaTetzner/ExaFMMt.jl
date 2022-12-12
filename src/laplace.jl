lib = ("/home/jt286/Documents/Code/C++/exafmm-t/build-release/julia/libExaFMMCInterface")

function LaplaceFMM(ncrit, p)

    return ccall(
        (:LaplaceFMM, lib),
        Ptr{Cvoid},
        (Cint, Cint),
        ncrit,
        p
    )
end

function setup_laplace(sources::Ptr{Cvoid}, targets::Ptr{Cvoid}, fmm::Ptr{Cvoid})

    return ccall(
        (:setup_laplace, lib),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid})
        sources,
        targets,
        fmm
    )
end

function evaluate_laplace(constructor::Ptr{Cvoid})

    return ccall(
        (:evaluate_laplace, lib),
        Ptr{Cdouble},
        (Ptr{Cvoid},)
        constructor
    )
end