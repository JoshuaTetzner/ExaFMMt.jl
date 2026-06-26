using Test
using TestItems
using TestItemRunner
using ExaFMMt
using Random

Random.seed!(1234)

@testset "fmm" begin
    include("test_laplace.jl")
    include("test_helmholtz.jl")
    include("test_modifiedhelmholtz.jl")
end

@testitem "Code quality (Aqua.jl)" begin
    using Aqua
    using ExaFMMt
    Aqua.test_all(ExaFMMt)
end

@testitem "Code formatting (JuliaFormatter.jl)" begin
    using JuliaFormatter
    using ExaFMMt
    @test JuliaFormatter.format(pkgdir(ExaFMMt), overwrite=false)
end

@run_package_tests verbose = true
