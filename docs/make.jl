using Documenter, ExaFMMt

makedocs(
    sitename = "ExaFMMt.jl",
    modules = [ExaFMMt],
    pages = [
        "Home" => "index.md",
        "Getting Started" => "gettingstarted.md",
        "Types and Functions" => "functions_types.md",
        "Examples" => "examples.md",
        "Avanced Topics" => "advancedtopics.md" 
    ]
)

deploydocs(
    repo = "github.com/JoshuaTetzner/ExaFMMt.jl.git",
    devbranch = "doc/documentation2",
    versions = nothing,
)