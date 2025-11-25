# [Running the model](@id model)

To run the TethysChloris.jl model, you need to have the input files prepared as described in the [Preparing the model inputs](@ref inputs) section. Once you have the configuration and forcing files ready, you can proceed to run the model.

The model is designed to be run in a Julia environment. You can use the following steps to execute the model:

1. **Open a Julia REPL**: Start Julia in your terminal or command prompt.
2. **Load the TethysChloris.jl package**: Use the Julia package manager to load the TethysChloris.jl package. If you have installed it as described in the [Installing TethysChloris.jl](@ref installation) section, you can load it with:

   ```julia
   using TethysChloris
   ```

3. **Load the configuration and forcing files**: You need to specify the paths to your configuration and forcing files and load the associated data. For example:

   ```julia
   yaml_file = "path/to/configuration.yaml"
   forcing_file = "path/to/forcing.nc"
   ```

4. **Initialize the model**: Create an instance of the model using the two files, as well as specifying the data type (e.g., `Float64`):

   ```julia
   model = initialize_model(Float64, forcing_data, yaml_data)
   ```

5. **Specify the model options**: You can set various options for the model, in the form of a `ModelOptions` type. These options control different aspects of the model's behavior. For example:

    ```julia
   options = ModelOptions(
      SoilTemperature = true,
      FreezingSoil = true,
      VegetationSnowInteractions = true,
      OPT_ST = ZeroFindingOptions(FT; rtol = 0.1),
      OPT_ST2 = ZeroFindingOptions(FT; rtol = 0.1),
      OPT_VD = ODEOptions(; abstol = 0.05),
   )
   ```

6. **Run the model**: Finally, you can run the model with the specified options, specifying the number of time steps. For example, to run the model for 3 days, you can use:

   ```julia
   NNd = 3
   NN = NNd * 24
   ALB, CK1, Ck, DQ = run_simulation(model; NN = NN, options = options)
   ```

Please note that the simulation results will be stored in the model instance, and you can access them for further analysis or visualization.

## Specifying model options

### ModelOptions

```julia
"""
    ModelOptions <: AbstractModelOptions

Structure that contains model options.

Available options:
- `SoilBiogeochemistry`: Enable soil biogeochemistry module. Corresponds to
    `OPT_SoilBiogeochemistry` in the original MATLAB code.
- `SoilTemperature`: Enable more detailed soil temperature calculation. Corresponds to
    `OPT_SoilTemp` in the original MATLAB code.
- `EnvLimitGrowth`: Enable environmental limitation on growth. Corresponds to `OPT_EnvLimitGrowth` in the
    original MATLAB code.
- `VegetationCoverArea`: Enable dynamic vegetation cover area. Corresponds to `OPT_VCA` in the
    original MATLAB code.
- `DynamicRootDepth`: Enable dynamic root depth. Corresponds to `OPT_DROOT` in the original
    MATLAB code.
- `Wetland`: Enable wetland module. Corresponds to `OPT_WET` in the original MATLAB code.
- `FreezingSoil`: Enable soil freezing/thawing. Corresponds to `OPT_FR_SOIL` in the original
    MATLAB code.
- `VegetationSnowInteractions`: Enable vegetation-snow interactions. Corresponds to
    `OPT_VegSnow` in the original MATLAB code.
- `PlantHydraulics`: Enable plant hydraulics. Corresponds to `OPT_PlantHydr` in the original
    MATLAB code.
- `AllometricScaling`: Allometric scaling option. Corresponds to `OPT_ALLOME` in the original
    MATLAB code. Possible values:
    - 1: Oil palm specific allometry
    - 2: Generic forest allometry
    - 3: Placeholder for specific forest types (allometry not implemented)
    - 4: Eucalyptus Regnans specific allometry
- `MinSPD`: Minimum snowpack depth to have a multilayer snow [m]. Corresponds to
    `OPT_min_SPD` in the original MATLAB code.
- `OPT_ST`: parameters for the zero-finding algorithm in the calculation of the surface
    temperature in the one layer situation
- `OPT_ST2`: parameters for zero-finding algorithm in the calculation of the surface
    temperature in the two layer situation
- `OPT_CR`: parameters for the zero-finding algorithm in the calculation of canopy
resistance
- `OPT_SM`: parameters for the ODE solver of the soil moistures
- `OPT_VD`: parameters for the ODE solver of the vegetation dynamics
- `OPT_PH`: parameters for the ODE solver of the plant hydraulics

Notes:
- `OPT_STh` is not implemented, as the code is never reached in the original MATLAB code due to
    `OPZ_SOLV` being hard-coded to 1
"""
```

`OPT_ST`, `OPT_ST2`, `OPT_CR` are of type `ZeroFindingOptions`, while `OPT_SM`, `OPT_VD`, and `OPT_PH` are of type `ODEOptions`, both detailed below.

### ZeroFindingOptions

```julia
"""
    ZeroFindingOptions <: AbstractZeroFindingOptions

# Fields
- `method::Roots.AbstractUnivariateZeroMethod`: Method for root finding (default: `Roots.Order0()`)
- `xatol::AbstractFloat`: Absolute tolerance for the root finding (default: method-dependent)
- `xrtol::AbstractFloat`: Relative tolerance for the root finding (default: method-dependent)
- `atol::AbstractFloat`: Absolute tolerance for the function value (default: method-dependent)
- `rtol::AbstractFloat`: Relative tolerance for the function value (default: method-dependent)
- `maxiters::Int`: Maximum number of iterations (default: method-dependent)
"""
```

### ODEOptions

```julia
"""
    ODEOptions <: AbstractODEOptions

# Fields
- `abstol::AbstractFloat`: Absolute tolerance for the ODE solver (default: 1e-6)
- `reltol::AbstractFloat`: Relative tolerance for the ODE solver (default: 1e-3)

# Notes
The default values for the absolute and relative tolerances are chosen to replicate the
behavior of the MATLAB [`odeset`](https://ch.mathworks.com/help/matlab/ref/odeset.html#d126e1217941) defaults.
"""
```
    