using MKL
using LinearAlgebra
using Base.Threads
using Test

function greensfunction(
    src::Matrix{F},
    trg::Matrix{F}
) where {F <: Real}

    G = zeros(F, size(trg)[1], size(src)[1])

    @threads for row = 1:size(trg)[1]
        @threads for col = 1:size(src)[1]
            if src[row, :] != trg[col, :]
                r = norm(src[row, :] - trg[col, :])
                G[row, col] = 1/(4*pi*r)
            end
        end
    end

    return G
end

n = 1000
points = rand(Float64, n, 3)
x = rand(Float64, n)

G = greensfunction(points, points)

Ap2 = setup(points, points, LaplaceFMMOptions(;p=2))
Ap8 = setup(points, points, LaplaceFMMOptions(;p=8))

yp2 = Ap2 * x
yp8 = Ap8 * x
ytrue = G * x

ϵ = verify(Ap2, Ap2.fmmoptions)[1]

@show relerrp2 = norm(yp2[:, 1] - ytrue) / norm(ytrue)
@show relerrp8 = norm(yp8[:, 1] - ytrue) / norm(ytrue)

@test relerrp2 < 1e-2
@test relerrp8 < 1e-8

@test eltype(yp2) == Float64

#Test Float32 version 
points = rand(Float32, n, 3)
x = rand(Float32, n)

G = greensfunction(points, points)

A = setup(points, points, LaplaceFMMOptions())
eltype(A)
y = A * x
ytrue = G * x
ϵ = verify(A, A.fmmoptions)[1]

@test norm(y[:, 1] - ytrue) / norm(ytrue) ≈ 0 atol=3ϵ
@test eltype(y) == Float32