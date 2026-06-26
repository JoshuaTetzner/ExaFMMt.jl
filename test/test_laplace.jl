using MKL
using LinearAlgebra
using Base.Threads
using Test

@views function greensfunction(src::Matrix{F}, trg::Matrix{F}) where {F<:Real}
    G = zeros(F, size(trg, 1), size(src, 1))

    @threads for row in 1:size(trg, 1)
        for col in 1:size(src, 1)
            if trg[row, :] != src[col, :]
                r = norm(trg[row, :] - src[col, :])
                G[row, col] = 1/(4*pi*r)
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

G = greensfunction(sources, targets)

Ap2 = setup(sources, targets, LaplaceFMMOptions(; p=2))
Ap8 = setup(sources, targets, LaplaceFMMOptions(; p=8))

yp2 = Ap2 * x
yp8 = Ap8 * x
yp8full = evaluate(Ap8, x, Ap8.fmmoptions)
ytrue = G * x

ϵ = verify(Ap2, Ap2.fmmoptions)[1]

@show relerrp2 = norm(yp2 - ytrue) / norm(ytrue)
@show relerrp8 = norm(yp8 - ytrue) / norm(ytrue)

@test relerrp2 < 1e-2
@test relerrp8 < 1e-8

@test eltype(yp2) == Float64
@test eltype(Ap8) == Float64
@test eltype(typeof(Ap8)) == Float64
@test size(Ap8) == (ntargets, nsources)
@test size(Ap8, 1) == ntargets
@test size(Ap8, 2) == nsources
@test size(transpose(Ap8)) == (nsources, ntargets)
@test size(adjoint(Ap8)) == (nsources, ntargets)
@test yp8 == yp8full[:, 1]

yp8_mul = similar(yp8)
mul!(yp8_mul, Ap8, x)
@test yp8_mul == yp8
yp8_mul_mat = similar(yp8, length(yp8), 1)
mul!(yp8_mul_mat, Ap8, x)
@test vec(yp8_mul_mat) == yp8
@test_throws ArgumentError transpose(Ap8) * rand(Float64, size(Ap8, 1))

close(Ap2)
@test_throws ArgumentError Ap2 * x
@test_throws ArgumentError evaluate(Ap2, x, Ap2.fmmoptions)
close(Ap2)
@test_throws DimensionMismatch evaluate(Ap8, rand(Float64, nsources + 1), Ap8.fmmoptions)
@test_throws ArgumentError setup(
    rand(Float64, 10, 2), rand(Float64, 10, 3), LaplaceFMMOptions()
)
@test_throws ArgumentError setup(
    rand(Float64, 10, 3), rand(Float32, 10, 3), LaplaceFMMOptions()
)
@test_throws ArgumentError setup(
    rand(Float64, 10, 3), rand(Float64, 10, 3), LaplaceFMMOptions(; p=0)
)
close(Ap8)

#Test Float32 version 
sources = rand(Float32, nsources, 3)
targets = rand(Float32, ntargets, 3)
x = rand(Float32, nsources)

G = greensfunction(sources, targets)

A = setup(sources, targets, LaplaceFMMOptions())
@test eltype(A) == Float32
y = A * x
ytrue = G * x
ϵ = verify(A, A.fmmoptions)[1]

@test norm(y - ytrue) / norm(ytrue) ≈ 0 atol=3ϵ
@test eltype(y) == Float32
close(A)
