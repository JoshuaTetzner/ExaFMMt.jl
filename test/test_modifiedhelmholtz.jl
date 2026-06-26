using MKL
using LinearAlgebra
using Base.Threads
using Test

@views function greensfunction(src::Matrix{F}, trg::Matrix{F}, k::F) where {F<:Real}
    G = zeros(F, size(trg, 1), size(src, 1))

    @threads for row in 1:size(trg, 1)
        for col in 1:size(src, 1)
            if trg[row, :] != src[col, :]
                r = norm(trg[row, :] - src[col, :])
                G[row, col] = exp(-k*r)/(4*pi*r)
            end
        end
    end

    return G
end

nsources = 900
ntargets = 700
sources = rand(Float64, nsources, 3)
targets = rand(Float64, ntargets, 3)
x = rand(Float64, nsources)
wavek = Float64(1.0)

G = greensfunction(sources, targets, wavek)
A = setup(sources, targets, ModifiedHelmholtzFMMOptions(wavek))

y = A * x
ytrue = G * x
ϵ = verify(A, A.fmmoptions)[1]

@test norm(y - ytrue) / norm(ytrue) ≈ 0 atol=3ϵ
@test eltype(y) == Float64
@test_throws ArgumentError setup(
    sources, targets, ModifiedHelmholtzFMMOptions(Float32(1.0))
)
close(A)

#Test Float32 version 
sources = rand(Float32, nsources, 3)
targets = rand(Float32, ntargets, 3)
x = rand(Float32, nsources)
wavek = Float32(1.0)

G = greensfunction(sources, targets, wavek)

A = setup(sources, targets, ModifiedHelmholtzFMMOptions(wavek))

y = A * x
ytrue = G * x
ϵ = verify(A, A.fmmoptions)[1]

@test norm(y - ytrue) / norm(ytrue) ≈ 0 atol=5ϵ
@test eltype(y) == Float32
close(A)
