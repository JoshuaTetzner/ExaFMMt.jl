lib = ("/home/jt286/Documents/Code/C++/exafmm-t/build-release/julia/libExaFMMCInterface")

function ModifiedHelmholtzFMM(ncrit, p)

    return ccall(
        (:ModifiedHelmholtzFMM, lib),
        Ptr{Cvoid},
        (Cint, Cint, Cdouble),
        ncrit,
        p, 
        wavek
    )
end

function setup_modifiedhelmholtz(sources::Ptr{Cvoid}, targets::Ptr{Cvoid}, fmm::Ptr{Cvoid})

    return ccall(
        (:setup_modifiedhelmholtz, lib),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid})
        sources,
        targets,
        fmm
    )
end

function evaluate_modifiedhelmholtz(constructor::Ptr{Cvoid})

    return ccall(
        (:evaluate_modifiedhelmholtz, lib),
        Ptr{Cdouble},
        (Ptr{Cvoid},)
        constructor
    )
end