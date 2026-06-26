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

deploydocs(;
    repo="github.com/JoshuaTetzner/ExaFMMt.jl.git",
    target="build",
    devbranch="dev",
    versions=["stable" => "v^", "dev" => "dev"],
)
