using Documenter, ExaFMMt

DocMeta.setdocmeta!(ExaFMMt, :DocTestSetup, :(using ExaFMMt); recursive=true)

makedocs(;
    sitename="ExaFMMt.jl",
    modules=[ExaFMMt],
    pages=[
        "Introduction" => "index.md",
        "Manual" => Any[
            "General Usage" => "./manual/manual.md",
            "Application Examples" => "./manual/examples.md",
        ],
        "Further Details" => Any[
            "Fast Multipole Method" => "./details/fmm.md",
            "FMM with the BEM" => "./details/bem.md",
        ],
        "Contributing" => "contributing.md",
        "API Reference" => "apiref.md",
    ],
)

# The @example blocks run real FMMs, and exafmm-t writes precomputation *.dat
# files into the working directory (which Documenter sets inside the build tree).
# Remove them so they are not deployed to gh-pages.
for (root, _, files) in walkdir(joinpath(@__DIR__, "build"))
    for f in files
        endswith(f, ".dat") && rm(joinpath(root, f))
    end
end

deploydocs(;
    repo="github.com/JoshuaTetzner/ExaFMMt.jl.git",
    target="build",
    devbranch="dev",
    versions=["stable" => "v^", "dev" => "dev"],
)
