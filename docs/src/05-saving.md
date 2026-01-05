# [Saving the simulation results](@id saving)

After running a simulation with the TethysChloris.jl model, you may want to save the results for future analysis or sharing. The package provides a `save` function to export the inputs and outputs to a (compressable) zip file. This file will contain

* the input YAML file
* the input NetCDF forcing file
* the simulation results as a NetCDF file.

```julia
save(model, "path/to/outputs.zip"; compress = true)
```

## Specifying variables to save

By default, the `save` function will store all the available output variables in the NetCDF results file. However, you can specify a subset of variables to save by providing a list of variable names using the `outputs` keyword argument. For example, to save only the variables "LAI_L" and "Vice", you can use:

```julia
save(model, "path/to/outputs.zip"; outputs = ["LAI_L", "Vice"], compress = true)
```
