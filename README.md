# VisClaw with Julia
This repository aims to become one of the Clawpack visualization tools (see http://www.clawpack.org).  
This allows us to make animations with the Julia language.   
Please contact the author if you find a bug.  

# Requirements
## Julia Packages
- Julia v1.0.0
- Plots
- PyPlot  (GR is also available)

## Others  
In order to make animations, the following softwares are necessary.  
- bash
- convert (ImageMagick)
- ffmpeg

# Usage Examples
In preparation, set a variable `CLAW` in `CLAWPATH.jl`  
```julia
CLAW="../clawpack" # path to your clawpack directory
```
This process can be skipped when OS is Linux.

## Chile 2010 Tsunami
- execute the example of `chile2010` in your clawpack
- update flags to meet your requirements in `example_chile2010.jl`
```julia
#= boolgauge[load,plot,print] =#
boolgauge = [1,1,1] .|> Bool
```
- start REPL and execute
```julia
include("./example_chile2010.jl")
```

The following animation and figures can be generated by `example_chile2010.jl`   

<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/gif/demo_chile2010.gif" width="380">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/fig/chile2010/topo.svg" width="380">  
</p>  
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/fig/chile2010/gauge32412.svg" width="480">
</p>  

## Hurricane Ike
- execute the example of `ike` in your clawpack, as is the case of `chile2010`
- update flags to meet your requirements in `example_ike.jl`
- start REPL and execute
```julia
include("./example_ike.jl")
```

<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/gif/demo_ike.gif" width="480">
</p>  
<p align="center">
<img src="https://github.com/hydrocoast/visclaw_julia/blob/master/fig/ike/allgauges.svg" width="480">
</p>  

## Easy Check
`easycheck.jl` enables to scan water surface elevation at certain times quickly.
```plain
julia> include("./easycheck.jl")
Input anything but integer if you want to exit.
The final step: 19
input the number (1 to 19) =
```

# License
BSD 3-Clause  

# Author
Takuya Miyashita   
miyashita(at)hydrocoast.jp  
Doctoral student, Kyoto University  
([personal web site](https://hydrocoast.jp))  
