using Test
using ExaFMMt

@testset "fmm" begin
    include("test_laplace.jl")
    include("test_helmholtz.jl")
    include("test_mdifiedhelmholtz.jl")
end