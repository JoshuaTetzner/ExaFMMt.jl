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

@testitem "Static analysis (JET.jl)" begin
    using JET
    using ExaFMMt
    # Restrict analysis to ExaFMMt's own code so the ccall / Exafmmt_jll FFI
    # boundary and Base/stdlib internals are not reported.
    JET.test_package(ExaFMMt; target_modules=(ExaFMMt,))
end

@testitem "Explicit imports (ExplicitImports.jl)" begin
    using ExplicitImports
    using ExaFMMt
    @test ExplicitImports.check_no_stale_explicit_imports(ExaFMMt) === nothing
    @test ExplicitImports.check_all_explicit_imports_via_owners(ExaFMMt) === nothing
    @test ExplicitImports.check_no_self_qualified_accesses(ExaFMMt) === nothing
end

@run_package_tests verbose = true
