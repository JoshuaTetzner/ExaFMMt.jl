using MKL
using LinearAlgebra
using Base.Threads
using Test

@views function greensfunction(
    src::Matrix{F}, trg::Matrix{F}, wavek::C
) where {F<:Real,C<:Complex}
    G = zeros(C, size(trg, 1), size(src, 1))

    @threads for row in 1:size(trg, 1)
        for col in 1:size(src, 1)
            if trg[row, :] != src[col, :]
                r = norm(trg[row, :] - src[col, :])
                G[row, col] = exp(im*wavek*r)/(4*pi*r)
            end
        end
    end

    return G
end

nsources = 900
ntargets = 700
sources = rand(Float64, nsources, 3)
targets = rand(Float64, ntargets, 3)
x = rand(ComplexF64, nsources)
wavek = 4.0 + 3.0*im

G = greensfunction(sources, targets, wavek)
A = setup(sources, targets, HelmholtzFMMOptions(wavek))

y = A * x
ytrue = G * x
yfull = evaluate(A, x, A.fmmoptions)
ϵ = abs.(verify(A, A.fmmoptions)[1])

@test norm(y - ytrue) / norm(ytrue) ≈ 0 atol=3ϵ
@test eltype(y) == ComplexF64
@test eltype(A) == ComplexF64
@test eltype(typeof(A)) == ComplexF64
@test size(A) == (ntargets, nsources)
@test size(transpose(A)) == (nsources, ntargets)
@test size(adjoint(A)) == (nsources, ntargets)
@test y == yfull[:, 1]
@test_throws ArgumentError adjoint(A) * rand(ComplexF64, size(A, 1))
@test_throws ArgumentError setup(
    sources, targets, HelmholtzFMMOptions(ComplexF32(1.0 + im))
)
close(A)

#Test Complex32 version 
sources = rand(Float32, nsources, 3)
targets = rand(Float32, ntargets, 3)
x = rand(ComplexF32, nsources)
wavek = ComplexF32(4.0 + 3.0*im)

G = greensfunction(sources, targets, wavek)
A = setup(sources, targets, HelmholtzFMMOptions(wavek))

y = A * x
ytrue = G * x
ϵ = abs.(verify(A, A.fmmoptions)[1])

@test norm(y - ytrue) / norm(ytrue) ≈ 0 atol=3ϵ
@test eltype(y) == ComplexF32
close(A)
