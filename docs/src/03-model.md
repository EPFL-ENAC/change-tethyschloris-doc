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
      OPT_ST = ZeroFindingOptions(FT),
      OPT_ST2 = ZeroFindingOptions(FT),
      OPT_VD = ODEOptions(; abstol = 0.05),
   )
   ```

   Please be aware that the surface temperature solver options (`OPT_ST` and `OPT_ST2`) have a significant impact on the model's performance and accuracy. You may need to experiment with different solver orders (e.g., `Roots.Order0()`, `Roots.Order1()`, `Roots.Order2()`) to find the best fit for your specific application. For instance, the Zurich test case has been found to perform well with `Roots.Order0()`, while the Vaira test case works better with `Roots.Order1()`. However, switching between these may cause the model to fail to converge in the other case. To specify the solver, you can set the `OPT_ST` field of the `ModelOptions` to any of the [non-bracketing solvers of `Roots.jl`](https://juliamath.github.io/Roots.jl/stable/roots/#Non-bracketing-methods), e.g., `ZeroFindingOptions(FT, Roots.Order0())`.

6. **Run the model**: Finally, you can run the model with the specified options, specifying the number of time steps. For example, to run the model for 3 days, you can use:

   ```julia
   NNd = 3
   NN = NNd * 24
   ALB, CK1, Ck, DQ = run_simulation(model; NN = NN, options);
   ```

   The `run_simulation` function will execute the model for the specified number of time steps and return the mass balance and water change checks.

Please note that the simulation results will be stored in the model instance, and you can access them for further analysis or visualization.
