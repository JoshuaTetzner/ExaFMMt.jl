lib = ("/home/jt286/Documents/Code/C++/exafmm-t/build-release/julia/libExaFMMCInterface")

function init_sources(points::Matrix{Float64}, charges::Vector{Float64})
    if size(points)[2] != 3
        throw("Only 3D distributions.")
    end
    if size(points)[1] != length(charges)
        throw("Charges and sources must be of same length.")
    end

    return ccall(
        (:init_sources_F64, lib),
        Ptr{Cvoid},
        (Ptr{Cdouble}, Ptr{Cdouble}, Cint),
        vec(points),
        charges,
        length(charges)
    )
end

function init_sources(points::Matrix{Float64}, charges::Vector{ComplexF64})
    if size(points)[2] != 3
        throw("Only 3D distributions.")
    end
    if size(points)[1] != length(charges)
        throw("Charges and sources must be of same length.")
    end

    return ccall(
        (:init_sources_C64, lib),
        Ptr{Cvoid},
        (Ptr{Cdouble}, Ptr{Cdouble}, Cint),
        vec(points),
        charges,
        length(charges)
    )
end

function init_targets(points::Matrix{Float64}; T=Float64)
    if size(points)[2] != 3
        throw("Only 3D distributions.")
    end

    return ccall(
        (:init_targets_F64, lib),
        Ptr{Cvoid},
        (Ptr{Cdouble}, Cint),
        vec(points),
        length(size(points[1]))
    )
end

function init_targets(points::Matrix{Float64}; T=ComplexF64)
    if size(points)[2] != 3
        throw("Only 3D distributions.")
    end
    println("here")
    return ccall(
        (init_targets_C64, lib),
        Ptr{Cvoid},
        (Ptr{Cdouble}, Cint),
        vec(points),
        length(size(points[1]))
    )
end

function update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{Float64})

    return ccall(
        (update_charges_real, lib),
        Cvoid,
        (Ptr{Cvoid}, Ptr{Cdouble}),
        fmmstruct,
        charges
    )
end

function update_charges(fmmstruct::Ptr{Cvoid}, charges::Vector{ComplexF64})

    return ccall(
        (update_charges_cplx, lib),
        Cvoid,
        (Ptr{Cvoid}, Ptr{ComplexF64}),
        fmmstruct,
        charges
    )
end

function clear_values(fmmstruct::Ptr{Cvoid})

    return ccall(
        (:clear_values, lib),
        Cvoid,
        (Ptr{Cvoid}),
        fmmstruct
    )
end