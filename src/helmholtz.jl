lib = ("/home/jt286/Documents/Code/C++/exafmm-t/build-release/julia/libExaFMMCInterface")

function HelmholtzFMM(ncrit, p, wavek)

    return ccall(
        (:HelmholtzFMM, lib),
        Ptr{Cvoid},
        (Cint, Cint, ComplexF64),
        ncrit,
        p,
        wavek
    )
end

function setup_helmholtz(sources::Ptr{Cvoid}, targets::Ptr{Cvoid}, fmm::Ptr{Cvoid})

    return ccall(
        (:setup_helmholtz, lib),
        Ptr{Cvoid},
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid})
        sources,
        targets,
        fmm
    )
end

function evaluate_helmholtz(constructor::Ptr{Cvoid})

    return ccall(
        (:evaluate_helmholtz, lib),
        Ptr{ComplexF64},
        (Ptr{Cvoid},)
        constructor
    )
end