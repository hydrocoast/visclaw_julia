# VisClaw with Julia
This repository aims to become one of the Clawpack visualization tools (see http://www.clawpack.org).  
This allows us to make animations with the Julia language like the following one:   
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_eta_GMT.gif", width="500">
</p>  

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

# Usage Examples
You can skip it when your OS is Linux.  
In preparation, set a variable `CLAW` in `src/CLAWPATH.jl`  
```julia
CLAW="path/to/your/clawpack"
```

Execute the Julia scripts in `examples/` after the simulations of chile2010 and ike in the GeoClaw examples.  
GMT.jl and Plots.jl are available for visualization of the numerical results.  

## GMT.jl

- sea surface elevation
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_eta_GMT.gif", width="400">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_eta_GMT.gif", width="400">
</p>  


- topography and bathymetry
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_topo.png", width="400">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_topo.png", width="400">
</p>  

- seafloor deformation (dtopo)
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_dtopo.png", width="500">
</p>  

- storm
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_eta_GMT.gif", width="500">
</p>  


## Plots.jl

- sea surface elevation
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_eta.gif", width="400">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_eta.gif", width="400">
</p>  

- current
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_current.gif", width="500">
</p>  

- topography and bathymetry
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_topo.svg", width="400">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_topo.svg", width="400">
</p>  

- wavegauges
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/chile2010_waveform_gauge.svg", width="400">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/examples/ike_waveform_gauge.svg", width="400">
</p>  


# License
BSD 3-Clause  

# Author
Takuya Miyashita   
miyashita(at)hydrocoast.jp  
Doctoral student, Kyoto University  
([personal web site](https://hydrocoast.jp))  
