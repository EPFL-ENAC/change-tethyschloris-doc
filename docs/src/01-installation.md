# [Installing TethysChloris.jl](@id installation)

To use the TethysChloris package, you can install it by cloning it from its GitHub repository and adding it to your Julia environment. 

## Cloning the repository

In your terminal, run the following command to clone the repository:

```bash
git clone https://github.com/CHANGE-EPFL/TethysChloris.jl.git 
```

This will create a local copy of the TethysChloris.jl repository on your machine, along with all its history. Most of the time, this may be unnecessary, as you are likely only interested in using the latest version of the package.

To only clone the latest version, without the full history, you can use the `--depth 1` option:

> **Note:** Replace `<latest-tag>` with the latest release tag from [the releases page](https://github.com/CHANGE-EPFL/TethysChloris.jl/releases).

```bash
git clone --depth 1 --branch <latest-tag> https://github.com/CHANGE-EPFL/TethysChloris.jl.git
```

## Adding the package to your Julia environment

Open Julia's REPL, and run the following commands to add the package:

```julia
using Pkg
Pkg.develop(path="TethysChloris.jl")
```

Please note that the first installation may take up to 15 minutes as Julia will download and compile all the necessary dependencies for the package.
