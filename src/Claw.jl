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

include("./CLAWPATH.jl")
export CLAW

include("StructClaw.jl")
include("Data.jl")
include("Utils.jl")
include("LoadTopo.jl")
include("LoadFort.jl")
include("LoadGauge.jl")

using Plots:Plots
Plots.pyplot()
include("StructPlots.jl")
include("PlotsTools.jl")
include("PlotsTopo.jl")
include("PlotsDeform.jl")
include("easycheck.jl")

using GMT:GMT
include("StructGMT.jl")
include("PScmd.jl")
include("GMTTools.jl")
include("GMTDraw.jl")
include("bathtopo.jl")
include("surfaceall.jl")

end
