# VisClaw for Julian
This repository aims to become one of the Clawpack visualization tools (see http://www.clawpack.org).  
This allows us to make animations using the Julia language.   
Any bug report would be appreciated.   

# Requirements
## Julia Packages
- [Julia](https://github.com/JuliaLang/julia) v1.0.0 or later
- [Plots.jl](https://github.com/JuliaPlots/Plots.jl)
- [GR.jl](https://github.com/jheinen/GR.jl)
- [PyPlot.jl](https://github.com/JuliaPy/PyPlot.jl)
- [GMT.jl](https://github.com/GenericMappingTools/GMT.jl)

## Other Softwares  
- [GMT](https://github.com/GenericMappingTools/gmt) (Generic Mapping Tools)  

# Usage
- In preparation, set a variable `CLAW` in `src/CLAWPATH.jl`  
```julia
CLAW = "path/to/your/clawpack"
```
You can skip it when your OS is Linux.  


- Run the simulations of chile2010 `$CLAW/geoclaw/examples/tsunami/chile2010` and ike `$CLAW/geoclaw/examples/storm-surge/ike` in the GeoClaw examples.  


- Add `src/` of this package to `LOAD_PATH` in Julia.
```julia
push!(LOAD_PATH, "path/to/this/repo/src") # in /.julia/config/startup.jl
```


- Run the Julia scripts in `examples/` .  
GMT.jl and Plots.jl are available for visualization of the numerical results.  

# Examples
## GMT.jl

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

### storm
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_storm_GMT.gif", width="400">
</p>  


## Plots.jl

### sea surface elevation
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_eta.gif", width="400">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_eta.gif", width="400">
</p>  

### current
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_current.gif", width="400">
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
