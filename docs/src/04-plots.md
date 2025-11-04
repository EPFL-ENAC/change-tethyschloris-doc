# [Plotting the simulation results](@id plots)

Following the execution of the TethysChloris.jl model, you may want to visualize the results to better understand the model's behavior and outputs. The package provides a set of plotting functions that can be used to create various types of plots based on the simulation results.

## Plotting Functions

The plotting functions are designed to work with the model's output data. You can use these functions to create plots of different variables, such as soil moisture, vegetation growth, and other biogeochemical parameters.

### Example of Plotting

To plot the results of your model simulation, you can follow these steps:

```julia
using TethysChloris.Figures

plot_meteorological(model, NN)
plot_soil_moisture(model, NN)
plot_evaporation_transpiration(model, NN)
plot_temperature_fluxes(model, NN)
plot_resistances(model, NN)
plot_stomatal_resistances(model, NN)
plot_interception(model, NN)
plot_daily_transpiration(model, NN)
plot_precipitation_drainage(model, NN)
plot_water_fluxes(model, NN)
plot_soil_water_depths(model, NN)
plot_water_table(model, NN)

# snow plots
plot_snow_coverage(model, NN)
plot_snow_characteristics(model, NN)
plot_snowpack_water(model, NN)
plot_snow_water(model, NN)

# ice plots
plot_ice(model, NN)
plot_ice_water(model, NN)

cc = 1

# vegetation plots
for k = 1:cc
    plot_assimilation(model, NN, k)
    plot_vegetation_dynamics(model, NNd, k)
    plot_phenology(model, NNd, k)
    plot_carbon_pools(model, NNd, k)
    plot_beta_factors(model, NNd, k)
end
```
