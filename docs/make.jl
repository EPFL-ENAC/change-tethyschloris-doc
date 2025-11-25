using Documenter
using Documenter.Remotes
using TethysChlorisDoc

DocMeta.setdocmeta!(TethysChlorisDoc, :DocTestSetup, :(using TethysChlorisDoc); recursive = true)

makedocs(;
    modules = [TethysChlorisDoc],
    authors = "Hugo Solleder <hugo.solleder@epfl.ch> and contributors",
    repo = Remotes.GitHub("EPFL-ENAC", "change-tethyschloris-doc"),
    sitename = "change-tethyschloris-doc",
    format = Documenter.HTML(;
        canonical = "https://EPFL-ENAC.github.io/change-tethyschloris-doc",
    ),
    pages = [
        "Home" => "index.md",
        "Installation" => "01-installation.md",
        "Input file formats" => "02-inputs.md",
        "Running the model" => "03-model.md",
        "Plotting the results" => "04-plots.md",
        "Saving the results" => "05-saving.md",
        "Flow overview" => "06-flow.md",
        "Contributing" => "90-contributing.md",
        "Developer docs" =>
            Any["Developer"=>"91-developer.md", "Debugging"=>"92-debugging.md"],
    ],
)

deploydocs(; repo = "github.com/EPFL-ENAC/change-tethyschloris-doc")
