# Visualization of the clawpack output
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

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

include("structclaw.jl")
include("loaddata.jl")
include("loadfgmaxgrid.jl")
include("amrutils.jl")
# Load
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
include("plotsgaugelocation.jl")
include("plotsfgmax.jl")

using GMT:GMT
# Setup
include("gmttools.jl")
include("gmttxtvelo.jl")
# make figures with GMT
include("gmtsurface.jl")
include("gmtstorm.jl")


include("run_examples.jl")
export run_examples

end
