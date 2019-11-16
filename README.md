# VisClaw for Julian
This repository aims to become one of the Clawpack visualization tools (see http://www.clawpack.org).  
This allows us to make figures and animations using the Julia language.   
Any bug report would be appreciated.   

# Requirements
## Julia packages
- [Julia](https://github.com/JuliaLang/julia) v1.0.0 or later
- [Plots.jl](https://github.com/JuliaPlots/Plots.jl)
- [GR.jl](https://github.com/jheinen/GR.jl)
- [GMT.jl](https://github.com/GenericMappingTools/GMT.jl)
- [Interpolations.jl](https://github.com/JuliaMath/Interpolations.jl)
- [GeometricalPredicates.jl](https://github.com/JuliaGeometry/GeometricalPredicates.jl)

## Other softwares  
- [GMT](https://github.com/GenericMappingTools/gmt) (Generic Mapping Tools)  

# Usage
- In preparation, run Clawpack numerical simulations
(e.g., chile2010 `$CLAW/geoclaw/examples/tsunami/chile2010` and
ike `$CLAW/geoclaw/examples/storm-surge/ike`).  

- Add the required packages in the Julia REPL.
```julia
]add Plots GMT GR Interpolations GeometricalPredicates
```
The [GMT](https://github.com/GenericMappingTools/gmt) program also needs to be installed if you want to plot using
[GMT.jl](https://github.com/GenericMappingTools/GMT.jl).
Note that GMT.jl does NOT install GMT.

- Clone this repository and add `src/` to `LOAD_PATH` in Julia.
```julia
push!(LOAD_PATH, "path/to/this/repo/src") # in ~/.julia/config/startup.jl
```

- Set an appropriate path to `CLAW` in `src/CLAWPATH.jl`.
You can skip it when the OS is Linux.  
```julia
# On Linux OS, "CLAW = ENV["CLAW"]" is automatically executed
CLAW = "path/to/your/clawpack"
```

- This package uses either GMT.jl or Plots.jl to plot numerical results.
Plots.jl is suitable for a quick check.
For example, a spatial distribution of the water surface height is plotted when you input as follows:
```julia
julia> using VisClaw
julia> simdir = joinpath(CLAW, "geoclaw/examples/tsunami/chile2010/_output");
julia> VisClaw.PlotsCheck(simdir; c=:balance, clims=(-0.5,0.5))
input a number (1 to 19) =
```
See also [Example1_Plots.ipynb](https://github.com/hydrocoast/visclaw_julia/blob/master/Example1_Plots.ipynb)
and [Example2_GMT.ipynb](https://github.com/hydrocoast/visclaw_julia/blob/master/Example2_GMT.ipynb) for more information.


# Examples
The following figures are generated with the Julia scripts in `examples/` .  

## using GMT.jl

### sea surface elevation
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_eta_GMT.gif", width="375">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_eta_GMT.gif", width="425">
</p>  


### topography and bathymetry
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_topo.png", width="350">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_topo.png", width="450">
</p>  

### seafloor deformation (dtopo)
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_dtopo.png", width="400">
</p>  

### wind and pressure fields
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_storm_GMT.gif", width="400">
</p>  


## using Plots.jl

### sea surface elevation
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_eta.gif", width="400">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_eta.gif", width="400">
</p>  

### flow velocity
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_velo.gif", width="400">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_velo.gif", width="400">
</p>  

### topography and bathymetry
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_topo.svg", width="400">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_topo.svg", width="400">
</p>  

### wave gauge
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_waveform_gauge.svg", width="400">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_waveform_gauge.svg", width="400">
</p>  

### fixed grid monitoring (fgmax)
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/fgmax4vars.svg", width="700">
</p>  


# License
BSD 3-Clause  

# Author
Takuya Miyashita   
miyashita(at)hydrocoast.jp  
Doctoral student, Kyoto University  
([personal web site](https://hydrocoast.jp))  
