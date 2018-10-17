__precompile__(false)
# Functions to load and print out the clawpack output
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

module Claw

using Statistics: mean
using DelimitedFiles: readdlm
using Printf
using Dates
using Interpolations

# define CLAW path from shell
include("./CLAWPATH.jl")
export CLAW

# define structs and basic functions
include("StructClaw.jl")
include("Data.jl")
include("Utils.jl")
# Load
include("LoadTopo.jl")
include("LoadFort.jl")
include("LoadGauge.jl")
# File convert for output
include("ConvertFiles.jl")

using Plots:Plots
Plots.pyplot()
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
include("GMTDraw.jl")
# make figures with GMT
include("GMTTopo.jl")
include("GMTSurfaceAll.jl")

end
