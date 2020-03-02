"""
# Visualization tool for the clawpack output
VisClaw.jl is a Julia package for plotting simulation results of the clawpack.\n
https://github.com/hydrocoast/VisClaw.jl

### Author
Takuya Miyashita (miyashita@hydrocoast.jp)\n
Doctoral student, Kyoto University, 2018\n
"""
module VisClaw

using Statistics: mean
using DelimitedFiles: readdlm
using Printf
using Dates

using Interpolations
using GeometricalPredicates: GeometricalPredicates
using Plots: Plots

# define CLAW path from shell
include("clawpath.jl")
export CLAW

# define structs and basic functions
const KWARG = Dict{Symbol,Any}
const emptyF = Array{Float64}(undef, 0, 0)
const timedict = Dict(:second => 1.0, :minute => 60.0, :hour => 3600.0, :day => 24*3600.0)
include("structclaw.jl")

include("amrutils.jl")
include("replaceunit.jl")
# Load
include("loaddata.jl")
include("loadfgmax.jl")
include("loadtopo.jl")
include("loadfort.jl")
include("loadgauge.jl")
# Convert mesh data
include("uniquemesh.jl")

# Setup
include("plotsargs.jl")
include("plotstools.jl")
# Plots
include("plots2d.jl")
include("plotscheck.jl")
include("plotstopo.jl")
include("plotsgaugewaveform.jl")
include("plotsgaugevelocity.jl")
include("plotsgaugelocation.jl")
include("plotsfgmax.jl")

using GMT:GMT
# Setup
include("gmttools.jl")
include("gmttxtvelo.jl")
# make figures with GMT
include("gmtsurface.jl")
include("gmtstorm.jl")

# run exapmles
include("run_examples.jl")

# General functions
export geodata, surgedata, gaugedata, fgmaxdata
export topodata, dtopodata
export loadfgmax, loadfgmaxgrid
export loadtopo, loaddeform, loaddtopo
export loadgauge
export loadsurface, loadcurrent, loadstorm
export rmvalue_coarser!
export axesratio
export replaceunit!

# functions with Plots.jl
export plotsamr
export plotscheck
export gridnumber!, tilebound!
export plotscoastline, plotscoastline!
export plotsfgmax, plotsfgmax!
export plotsfgmaxsurf
export plotstopo, plotstopo!
export plotsdtopo, plotsdtopo!
export plotstoporange, plotstoporange!
export plotsgaugelocation, plotsgaugelocation!
export plotsgaugewaveform, plotsgaugewaveform!
export plotsgaugevelocity, plotsgaugevelocity!
export plotsgif, plotssavefig

# functions with GMT.jl
export getR, getR_tile, getJ, geogrd
export landmask_asc, landmask_grd
export tilegrd, tilegrd_mask
export txtwind, txtwind_scale


end
