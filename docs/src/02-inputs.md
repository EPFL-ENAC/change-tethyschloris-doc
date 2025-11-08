# [Preparing the model inputs](@id inputs)

TethysChloris.jl requires two specific input files to run the model: a configuration file and a forcing file. These files are essential for defining the model's parameters and the environmental conditions under which it operates.

The configuration file is a YAML file that contains various parameters necessary for the model's operation. The dictionary will be used to initialize the model parameters. As such, most of the contents of the YAML file comes from the `MOD_PARAM_*` files in the original MATLAB code. When functions were used in the `MOD_PARAM_*` files, the corresponding Julia function are used directly during the creation of the model parameters. This is the case for `Soil_parameters` and `Soil_parametersII`.

The forcing file is a NetCDF file that provides the environmental data needed for the model. The NetCDF file is created using a mixture of the `MOD_PARAM_*` files and the MAT files associated with the original MATLAB code, as well as some hard-coded initialization values.

The `data-raw/create_input_data.jl` script is an example of how to create these input files from the original MATLAB data. This script is designed to generate the necessary input files in the correct format for TethysChloris.jl.

## [Detailed preparation of the model inputs](@id input_details)

To run TethysChloris.jl, you need to create two essential input files:

### A YAML configuration file containing model parameters

### A NetCDF file with forcing data and initial conditions for the state and auxiliary variables

Below are step-by-step instructions for creating these files from meteorological data.

## [Requirements](@id input_requirements)

You'll need the following Julia packages:

* `NCDatasets.jl` for handling NetCDF files
* `YAML.jl` for creating YAML configuration files
* `Dates` for date manipulation
* `MAT.jl` for reading MATLAB .mat files (if using MATLAB data sources)

These packages can be installed using Julia's package manager:

```julia
using Pkg
Pkg.add("NCDatasets")
Pkg.add("YAML")
Pkg.add("Dates")
Pkg.add("MAT")
```

## [Step 1: Data Sources](@id input_sources)

Your meteorological forcing data should include the following hourly variables:

- Date and time (as a single `Vector{DateTime}` object)
- Temperature (Ta)
- Precipitation (Pr)
- Wind speed (Ws)
- Vapor pressure (ea)
- Solar radiation components (SAD1, SAD2, SAB1, SAB2)
- Dew point temperature (Tdew)
- Saturation vapor pressure (esat)
- Photosynthetically active radiation (PARB, PARD)
- CO2 concentration (Ca)

## [Step 2: YAML File](@id input_yaml)

The YAML configuration file contains several parameter groups. Please note that some parameters that were explicitly calculated in the MATLAB `MOD_PARAM_*` files are now computed directly in the Julia composite types during model initialization.

### Basic parameters

```julia
Zs = FT.([0, 10, 20, 50, 100, 150, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1350, 1500])
n_layers = length(Zs) - 1

data = Dict{String,Any}()
data["n_layers"] = n_layers
```

### Cell properties

```julia
data["cell"] = Dict{String,Any}(
    "cellsize" => 1.0,
    "SvF" => 1.0,
    "SN" => 0.0,
    "Slo_top" => 0.0,
    "Ared" => 1.0,
    "aR" => 1.0,
)
```

The `Asur`, `Slo_pot`, `aTop`, `cosalp`, `sinalp` and `aTop_scaled` parameters are now calculated internally based on the `cellsize` and `Slo_top` parameters.

### Simulation settings

```julia
data["simulation"] = Dict{String,Any}(
    "Zs" => Zs,
    "dt" => 3600,
    "dtd" => 1,
    "Lon" => -120.9508,
    "Lat" => 38.4133,
    "DeltaGMT" => -8,
    "t_bef" => 0.25,
    "t_aft" => 0.75,
    "Zdes" => 10.0,
    "Zinf" => 10.0,
    "Zbio" => 250.0,
    "SPAR" => 2,
    "fpr" => 1.0,
    "CASE_ROOT" => 1,
    "zatm" => 2.0,
    "timerange" => [DateTime(2011, 10, 1, 0, 0), DateTime(2017, 9, 30, 23, 0)],
    "SPAR" => 2,
  )
```

The `timerange` parameter allows the user to specify the start and end dates for the simulation.
The `ms`, `dth`, `dz`, `Dz`, `EvL_Zs`, `Inf_Zs`, `Bio_Zs`, `timesteps` and `days` parameters are now calculated internally based on the `Zs`, `Zdes`, `Zinf`, `Zbio`, `dth`, and `timerange` parameters.

### Land cover information

```julia
data["landcover"] = Dict{String,Any}(
    "Cbare" => 0.0,
    "Cwat" => 0.0,
    "Curb" => 0.0,
    "Crock" => 0.0,
    "Ccrown" => [1.0],
)
```

### Soil properties

```julia
data["soil"] = Dict{String,Any}(
    "Pcla" => 0.13,
    "Psan" => 0.30,
    "Porg" => 0.0139,
    "Kfc" => 0.2,
    "Phy" => 10000.0,
    "color_class" => 0,
)
```

The following parameters are now calculated internally using the `soil_parameters` and `Soil_parametersII` functions based on the `Pcla`, `Psan`, `Porg`, `Kfc` and `Phy` parameters:

- `Ks_Zs`
- `Osat`
- `Ohy`
- `L`
- `Pe`
- `O33`
- `alpVG`
- `nVG`
- `Ks_mac`
- `Omac`
- `alpVGM`
- `nVGM`
- `rsd`
- `lan_dry`
- `lan_s`
- `cv_s`
- `s_SVG`
- `bVG`
- `lVG`
- `lVGM`
- `Ofc`
- `K_usle`

### Debris cover parameters

```julia
data["debris"] = Dict{String,Any}(
    "alb" => 0.13,
    "e_sur" => 0.94,
    "lan" => 0.94,
    "rho" => 1496.0,
    "cs" => 948.0,
    "zom" => 0.016,
    "dbThick" => 0.0,
)
```

### Rock parameters

```julia
data["rock"] = Dict{String,Any}(
    "Kbot" => NaN64,
    "Krock" => NaN64,
    "In_max_rock" => 0.1
)
```

### Snow and ice parameters

```julia
data["snowice"] = Dict{String,Any}(
    "TminS" => -0.8,
    "TmaxS" => 2.8,
    "WatFreez_Th" => -8.0,
    "dz_ice" => 0.45,
    "Th_Pr_sno" => 8.0,
    "ros_max1" => 550.0,
    "ros_max2" => 300.0,
    "Ice_wc_sp" => 0.01,
    "ros_ice_thr" => 500.0,
    "Aice" => 0.28,
    "dir_vis" => 0.2,
    "dif_vis" => 0.2,
    "dir_nir" => 0.2,
    "dif_nir" => 0.2,
    "Sp_SN_In" => 5.9,
)
```

### Urban parameters

```julia
data["urban"] = Dict{String,Any}(
    "alb" => 0.15,
    "e_sur" => 0.92,
    "BuildH" => 12.0,
    "In_max_urb" => 5.0
)
```

### Vegetation parameters

```julia
data["vegetation"] = Dict{String, Any}(
    "gcI" => 3.7,
    "KcI" => 0.06,
    "Kct" => 0.75,
    "Sllit" => 2.0,
    "Oa" => 210000.0,
)

data["vegetation"]["high"] = Dict{String,Any}(
    "ZRmax" => [NaN64],
    "ZR50" => [NaN64],
    "Knit" => [0.2],
    "mSl" => [0.0],
    "FI" => [0.081],
    "Do" => [1000.0],
    "a1" => [7.0],
    "go" => [0.01],
    "CT" => [3],
    "DSE" => [0.649],
    "Ha" => [72.0],
    "gmes" => [Inf64],
    "rjv" => [2.8],
    "Vmax" => [0.0],
    "Psi_sto_00" => [-0.5],
    "Psi_sto_50" => [-2.0],
    "PsiL00" => [-2.7],
    "PsiL50" => [-5.6],
    "PsiX50" => [-3.5],
    "Kleaf_max" => [5.0],
    "Cl" => [1200.0],
    "Axyl" => [15.0],
    "Kx_max" => [80000.0],
    "Cx" => [150.0],
    "Sl" => [0.016],
    "Osm_reg_Max" => [0.0],
    "eps_root_base" => [0.9],
    "d_leaf" => [3.5],
    "Sp_LAI_In" => [0.2],
    "OM" => 1.0,
    "PFT_Class" => [0],
)

data["vegetation"]["low"] = Dict{String,Any}(
    ...
)
```

All parameters with bracketed values require one value per crown area. `data["vegetation"]["low"]` can be filled similarly with low vegetation parameters.

### Vegetation dynamics

The vegetation dynamics parameters are created as a vector of `Dict`, with one `Dict` per crown area.

```julia
data["vegetationdynamics"] = Dict{String,Any}()
data["vegetationdynamics"]["high"] = [Dict{String,Any}(
      "Sl" => 0.016,
      "mSl" => 0.0,
      "r" => 0.030,
      "gR" => 0.25,
      "LtR" => 1.0,
      "eps_ac" => 1.0,
      "aSE" => 5,
      "Trr" => 3.5,
      "dd_max" => 1/365,
      "dc_C" => 2/365,
      "Tcold" => 7.0,
      "drn" => 1/1095,
      "dsn" => 1/365,
      "age_cr" => 150.0,
      "Bfac_lo" => 0.95,
      "Bfac_ls" => NaN64,
      "Tlo" => 12.9,
      "Tls" => NaN64,
      "mjDay" => 180,
      "LDay_min" => 11.0,
      "dmg" => 35.0,
      "Mf" => 1/50,
      "Wm" => 1/16425,
      "LAI_min" => 0.01,
      "LDay_cr" => 12.30,
      "PsiG50" => -0.45,
      "PsiG99" => -1.2,
      "gcoef" => 3.5,
      "Klf" => 1/15,
      "fab" => 0.74,
      "fbe" => 0.26,
      "ff_r" => 0.1,
      "PAR_th" => NaN64,
      "PsiL50" => -5.6,
      "PsiL00" => -2.7,
      "Nl" => 30.0,
)]

data["vegetationdynamics"]["low"] = [Dict{String,Any}(
    ...
)]
```

### Vegetation management

```julia
data["vegetationmanagement"] = Dict{String,Any}(
    "high" => [
        Dict{String,Any}(
            "LAI_cut" => 0.0,
            "B_harv" => 0.0,
            "fract_log" => 0.0,
            "fire_eff" => 0.0,
            "funb_nit" => 0.15,
            "fract_girdling" => 0.0,
            "Crop_B" => [0.0, 0.0],
            "Crop_crown" => 1.0,
            "fract_resprout" => 0.2,
            "fract_left" => 1.0,
            "fract_left_fr" => 0.0,
            "fract_left_AB" => 0.0,
            "fract_left_BG" => 1.0,
        ),
    ],
)

data["vegetationmanagement"]["low"] = data["vegetationmanagement"]["high"]
data["vegetationmanagement"]["low"][1]["jDay_cut"] = [132, 168, 202, 238, 292]
data["vegetationmanagement"]["low"][1]["LAI_cut"] = 1.68
```

### Exudation parameters

```julia
data["exudation"] = Dict{String,Any}(
    "high" => [Dict{String,Any}("bfix" => false)],
    "low" => [Dict{String,Any}("bfix" => false)],
)
```

### Biogeochemistry parameters

```julia
data["biogeochemistry"] = Dict{String,Any}("PH" => 5.0, "ExEM" => 0.0)

data["biogeochemistry_io"] = Dict{String,Any}(
    "SC_par" => [1.0, 1.0, 1.0, 1.0],
    "Upl" => 0.01,
    "HIST" => false
)
```

### Save the YAML configuration

```julia
YAML.write_file("your_site_parameters.yaml", data)
```

## [Step 3: NetCDF File](@id input_netcdf)

The NetCDF file contains both forcing data and initial conditions. The `NCDatasets` can be used to create and manipulate NetCDF files in Julia, via the `defGroup`, `defDim`, and `defVar` functions. Before creating the initial conditions, the dimensions must be defined. Similarly, for height-dependent variables, the high and low vegetation groups must be created first.

### Initialize the NetCDF file

```julia
ds = NCDataset("your_site_data.nc", "c")

high_vegetation = defGroup(ds, "high_vegetation")
low_vegetation = defGroup(ds, "low_vegetation")
```

### Define dimensions

```julia
defDim(ds, "crownareas", 1)
defDim(ds, "carbonpools", 8)
defDim(ds, "nutrient", 3)
defDim(ds, "layers", length(Zs))
defDim(ds, "layerbelowsurface", n_layers)
...
```

### Add time variables

```julia
defVar(ds, "datetime", datetime_array, ("hours",))
```

### Add meteorological forcing data

```julia
defVar(ds, "Pr", precipitation_data, ("hours",))
defVar(ds, "Ta", temperature_data, ("hours",))
defVar(ds, "Ws", wind_speed_data, ("hours",))
defVar(ds, "ea", vapor_pressure_data, ("hours",))
defVar(ds, "SAD1", sad1_data, ("hours",))
defVar(ds, "SAD2", sad2_data, ("hours",))
defVar(ds, "SAB1", sab1_data, ("hours",))
defVar(ds, "SAB2", sab2_data, ("hours",))
defVar(ds, "Tdew", tdew_data, ("hours",))
defVar(ds, "esat", esat_data, ("hours",))
defVar(ds, "PARB", parb_data, ("hours",))
defVar(ds, "PARD", pard_data, ("hours",))
defVar(ds, "Ca", co2_data, ("hours",))

# Calculate vapor pressure deficit
Ds = max.(esat_data - vapor_pressure_data, 0)
defVar(ds, "Ds", Ds, ("hours",))
```

### Add soil layer information

```julia
defVar(ds, "Zs", soil_depths, ("layers",))
```

### Add initial conditions for state and auxiliary variables

For hydrologic state variables shared between high and low vegetation:

```julia
O = [
    0.3269,
    0.328,
    0.329,
    0.3314,
    0.3341,
    0.3367,
    0.3402,
    0.3442,
    0.3476,
    0.3505,
    0.3541,
    0.3564,
]
defVar(ds, "O", initial_soil_moisture, ("layerbelowsurface",))
defVar(ds, "Tdamp", 22.0, ())
...
```

For hydrologic state variables specific to high vegetation:

```julia

defVar(high_vegetation, "Ci_sun", [Ca[1]], ("crownareas",))
defVar(high_vegetation, "Ci_shd", [Ca[1]], ("crownareas",))
defVar(high_vegetation, "In", [0.0], ("crownareas",))
defVar(high_vegetation, "LAI_tot", [0.0], ("crownareas",))
...
```

### Close the NetCDF file

```julia
close(ds)
```

## [Existing Examples](@id input_examples)

The `create_vaira_data.jl` and `create_zurich_data.jl` scripts in the `data-raw` directory provide complete examples of creating input files for specific sites. You can adapt these scripts for your own site by:

1. Replacing the input data sources with your own meteorological data
2. Adjusting site-specific parameters (location, soil properties, vegetation characteristics)
3. Modifying initial conditions based on your site knowledge

By following these steps, you'll be able to create the necessary input files to run TethysChloris.jl with your own site data.
