using MKL
using LinearAlgebra
using Base.Threads

function greensfunction(
    src::Matrix{F},
    trg::Matrix{F},
    wavek::C
) where {F <: Real, C <: Complex}

    G = zeros(C, size(trg)[1], size(src)[1])

    @threads for row = 1:size(trg)[1]
        @threads for col = 1:size(src)[1]
            if src[row, :] != trg[col, :]
                r = norm(src[row, :] - trg[col, :])
                G[row, col] = exp(im*wavek*r)/(4*pi*r)
            end
        end
    end

    return G
end


n = 1000
points = rand(Float64, n, 3)
x = ComplexF64.(rand(Float64, n))
wavek = 0.0*im

G = greensfunction(points, points, wavek)
A = setup(points, points, HelmholtzFMMOptions(wavek))

y = A * x
ytrue = G * x
ϵ = real(verify(A, A.fmmoptions)[1])

@test norm(y[:, 1] - ytrue) / norm(ytrue) ≈ 0 atol=ϵ