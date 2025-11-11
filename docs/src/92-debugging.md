# [Debugging](@id debugging)

Debugging TethysChloris.jl can be challenging due to the complexity of the model and the interactions between its various components. Here are some strategies and tools that can help you identify and fix issues in your simulations.

## Visualizing the results

First and foremost, use the built-in plotting functions in the `Figures` submodule to visualize the results of your simulations. This can help you identify any unexpected behavior or trends in the data.

### Comparing the Julia results with MATLAB

If you have access to the original MATLAB implementation of the TethysChloris model, you can compare the results obtained from the Julia version with those from MATLAB. This can help you identify discrepancies and potential issues in the Julia implementation. Simply export the results from the MATLAB model as a `.mat` file at the end of the simulation, with the `save` function, before comparing the outputs with those from the Julia model.

```julia
using MAT
mat_data = matread("matlab_results.mat")

function plot_differences(matlab_variable, julia_variable, NNv)
    plot(
        NNv,
        [
            matlab_variable[NNv],
            julia_variable[NNv],
            matlab_variable[NNv] - julia_variable[NNv]
        ],
        label = ["MATLAB" "Julia" "Difference"],
        color = [:blue :red :green],
        grid = true,
    )
end

plot_differences(
    matlab_data["LAI_L"],
    model.auxiliary.vegetation.low.LAI,
    1:NNd,
)
```

You can create similar plots for other variables of interest. For example, to compare the biomass of low vegetation, with one plot per pool:

```julia
Nk = NNd
P = Vector{Any}(undef, 8)
for k = 1:8
    P[k] = plot(
        1:Nk,
        [
          matlab_data["B_L"][1:Nk, 1, k], 
          model.state.vegetation.low.B[1:Nk, 1, k], 
          matlab_data["B_L"][1:Nk, 1, k] - model.state.vegetation.low.B[1:Nk, 1, k]
        ],
        label = ["MATLAB" "Julia", "Difference"],
        color = [:blue :red :green],
        grid = true,
    )
end

plot(P..., layout = (2, 4), size = (1600, 800))
```

## Using a Debugger

For more in-depth debugging, you can use a Julia debugger such as [Debugger.jl](https://github.com/JuliaDebug/Debugger.jl). This package provides an interface for stepping through your code, inspecting variables, and evaluating expressions in the context of your running program.

Once installed, you can use it in your code as follows:

```julia
using Debugger

@enter your_function(args)
```

Alternatively, you can set breakpoints in the TethysChloris.jl source code and use the `@run` macro to start the debugger:

```julia
import TethysChloris
using Debugger

breakpoint(TethysChloris.ModuleName.FunctionName, line_number)
@run your_function(args)
```

However, using the Debugger.jl is limited for the following reasons:

* The model runs several ODE solvers or minimization routines, which are not easily stepped through and can be extremely time-consuming, as Debugger.jl stores the entire stack trace.
* Each function requires a large number of arguments, which makes it difficult to recreate a simple test case

To avoid the first issue, more lightweight debugging tools such as [Infiltrator.jl](https://github.com/JuliaDebug/Infiltrator.jl) can be helpful. Infiltrator.jl allows you to "infiltrate" a running Julia process and inspect its state without the overhead of a full debugger.

## Printing intermediate results

Another simple but effective debugging strategy is to add print statements throughout the source code to track the flow of execution and the values of key variables. This can help identify where things are going wrong and what might be causing the issue and has been one of the most time-efficient ways to debug the code so far. This approach, however, requires the user to clone the repository and modify the source code directly.

## Integrating MATLAB results for debugging

If you have access to the MATLAB results, you can integrate them into the Julia debugging process by loading the MATLAB `.mat` files directly into your Julia environment using the `MAT.jl` package, and then setting the model variable of interest to the corresponding MATLAB data over the simulation period. This allows you to isolate and test specific components of the model against known good data. In addition, you should disable the state saving functionality by commenting it out to avoid overwriting the MATLAB results during the simulation.
