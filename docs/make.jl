push!(LOAD_PATH, "../src/")

using Documenter
using StandardYoungTableaux

makedocs(
    sitename = "StandardYoungTableaux",
    authors = "Stéphane Laurent",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://stla.github.io/StandardYoungTableaux.jl",
        assets = String[],
    ),
    modules = [StandardYoungTableaux],
    pages = ["Documentation"  => "index.md"],
    repo = "https://github.com/stla/StandardYoungTableaux.jl/blob/{commit}{path}#{line}"
)

deploydocs(;
    branch = "gh-pages",
    devbranch = "main",
    repo = "github.com/stla/StandardYoungTableaux.jl",
)
