# [Debugging](@id debugging)

Debugging TethysChloris.jl can be challenging due to the complexity of the model and the interactions between its various components. Here are some strategies and tools that can help you identify and fix issues in your simulations.

## Visualizing the results

First and foremost, use the built-in plotting functions in the `Figures` submodule to visualize the results of your simulations. This can help you identify any unexpected behavior or trends in the data.

## Using a Debugger

For more in-depth debugging, you can use a Julia debugger such as [Debugger.jl](https://github.com/JuliaDebug/Debugger.jl). This package provides a powerful interface for stepping through your code, inspecting variables, and evaluating expressions in the context of your running program.

To use Debugger.jl, you first need to install it:

```julia
using Pkg
Pkg.add("Debugger")
```

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

However, using the Debugger.jl limited for the following reasons:

* The model runs several ODE solvers or minimization routines, which are not easily stepped through and can be extremely time-consuming, as Debugger.jl stores the entire stack trace.
* Each function requires a large number of arguments, which makes it difficult to recreate a simple test case

To avoid the first issue, more lightweight debugging tools such as [Infiltrator.jl](https://github.com/JuliaDebug/Infiltrator.jl) can be helpful. Infiltrator.jl allows you to "infiltrate" a running Julia process and inspect its state without the overhead of a full debugger.

## Printing intermediate results

Another simple but effective debugging strategy is to add print statements throughout the source code to track the flow of execution and the values of key variables. This can help identify where things are going wrong and what might be causing the issue and has been one of the most time-efficient ways to debug the code so far. This approach, however, requires the user to clone the repository and modify the source code directly.
