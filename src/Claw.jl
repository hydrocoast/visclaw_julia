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

include("DefStructs.jl")
include("Data.jl")
include("Utils.jl")
include("LoadTopo.jl")
include("LoadFort.jl")
include("LoadGauge.jl")

#using Plots:Plots
#Plots.pyplot()
#include("PlotTools.jl")

using GMT:GMT
include("GMTTools.jl")
include("GMTDraw.jl")


end
