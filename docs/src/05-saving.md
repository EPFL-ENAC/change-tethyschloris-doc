# [Saving the simulation results](@id saving)

After running a simulation with the TethysChloris.jl model, you may want to save the results for future analysis or sharing. The package provides a `save` function to export the state and auxiliary variables to a NetCDF file.

```julia
save(model, "path/to/outputs.nc", options)
```
