using Documenter, ExaFMMt

DocMeta.setdocmeta!(
    ExaFMMt,
    :DocTestSetup,
    :(using ExaFMMt);
    recursive=true,
)

makedocs(
    sitename="ExaFMMt.jl",
    modules=[ExaFMMt],
    pages=[
        "Home" => "index.md",
        "Getting Started" => "gettingstarted.md",
        "Types and Functions" => "functions_types.md",
        "Examples" => "examples.md",
        "Avanced Topics" => "advancedtopics.md"
    ]
)

deploydocs(;
    repo="github.com/JoshuaTetzner/ExaFMMt.jl.git",
    target="build",
    devbranch="dev",
    versions=["stable" => "v^", "dev" => "dev"],
)
