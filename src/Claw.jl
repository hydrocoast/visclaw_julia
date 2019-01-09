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
Plots.pyplot()

# define CLAW path from shell
include("CLAWPATH.jl")
export CLAW

# define structs and basic functions
include("StructClaw.jl")
include("Data.jl")
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
include("PlotsDraw.jl")
include("PlotsCheck.jl")
include("PlotsTopo.jl")
include("PlotsDeform.jl")
include("PlotsGauge.jl")
include("PlotsSurfaceAll.jl")

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
