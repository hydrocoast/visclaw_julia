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
Plots.plotly()
Plots.clibrary(:colorcet)

# define CLAW path from shell
include("CLAWPATH.jl")
export CLAW

# define structs and basic functions
const KWARG = Dict{Symbol,Any}
include("StructClaw.jl")
include("LoadData.jl")
include("Utils.jl")
# Load
include("LoadTopo.jl")
include("LoadFort.jl")
include("LoadGauge.jl")
# Convert files for output
include("ConvertFiles.jl")
# Convert mesh data
include("UniqueMesh.jl")

# Setup
include("StructPlots.jl")
include("PlotsTools.jl")
# Plots
include("Plots2D.jl")
include("PlotsCheck.jl")
include("PlotsTopo.jl")
include("PlotsDeform.jl")
include("PlotsGaugeWaveform.jl")
include("PlotsGaugeLocation.jl")
include("PlotsSurfaceAll.jl")
include("PlotsCurrentAll.jl")
include("PlotsStormAll.jl")
include("PlotsWindArrow.jl")

using GMT:GMT
# Setup
include("StructGMT.jl")
include("GMTTools.jl")
include("GMTColorbar.jl")
include("GMTTitle.jl")
include("GMTtxtvelo.jl")
include("GMTpsvelo.jl")
# make figures with GMT
include("GMTCoastlines.jl")
include("GMTTopo.jl")
include("GMTSurface.jl")
include("GMTSurfaceAll.jl")
include("GMTStorm.jl")
include("GMTStormAll.jl")

end
