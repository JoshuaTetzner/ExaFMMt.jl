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

A = setup(points, points, LaplaceFMMOptions())
y = A * x
ytrue = G * x
ϵ = verify(A, A.fmmoptions)[1]

@test norm(y[:, 1] - ytrue) / norm(ytrue) ≈ 0 atol=ϵ
