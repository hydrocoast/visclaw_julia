# Functions to load and print out the clawpack output
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

module Claw

using Statistics: mean
using DelimitedFiles: readdlm
using Printf
using Dates
using Interpolations


using GeometricalPredicates: GeometricalPredicates

using Plots:Plots

# define CLAW path from shell
include("CLAWPATH.jl")
export CLAW

# define structs and basic functions
const KWARG = Dict{Symbol,Any}
const emptyF = Array{Float64}(undef, 0, 0)

include("StructClaw.jl")
include("LoadData.jl")
include("LoadFGmaxGrid.jl")
include("Utils.jl")
# Load
include("LoadTopo.jl")
include("LoadFort.jl")
include("LoadGauge.jl")
# Convert mesh data
include("UniqueMesh.jl")

# Setup
include("PlotsArgs.jl")
include("PlotsTools.jl")
# Plots
include("Plots2D.jl")
include("PlotsCheck.jl")
include("PlotsTopo.jl")
include("PlotsGaugeWaveform.jl")
include("PlotsGaugeLocation.jl")
include("PlotsFGmax.jl")

using GMT:GMT
# Setup
include("GMTTools.jl")
include("GMTtxtvelo.jl")
# make figures with GMT
include("GMTSurface.jl")
include("GMTStorm.jl")

end
