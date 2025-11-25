# [Simulation flow](@id flow)

Running a simulation with the TethysChloris.jl model involves several steps:

## Cloning the repository

Follow the instructions in the [Installing TethysChloris.jl](@ref installation) section to clone the repository to your local machine.

## Create a folder structure

Create a folder structure for your simulation, containing the forcing data as MAT file(s), an outputs folder, and a scripts folder for your Julia scripts. For example:

```bash
/path/to/simulation/
├── data/
│   ├── forcing.mat 
│   └── other_forcing.mat
├── outputs/
└── scripts/
    ├── create_input_files.jl
    └── run_simulation.jl
```

## Add the TethysChloris.jl package to your Julia environment

```julia
using Pkg
Pkg.develop(path="/path/to/TethysChloris.jl")
```

## Create a Julia script to create the NetCDF and YAML file

Follow a structure similar to the [example scripts](https://github.com/CHANGE-EPFL/TethysChloris.jl/tree/main/data-raw) provided in the TethysChloris.jl repository.

## Run the simulation

Follow a structure similar to the [Zurich](https://github.com/CHANGE-EPFL/TethysChloris.jl/blob/main/zurich_example.jl) and [Vaira](https://github.com/CHANGE-EPFL/TethysChloris.jl/blob/main/vaira_example.jl) example scripts provided in the TethysChloris.jl repository.
