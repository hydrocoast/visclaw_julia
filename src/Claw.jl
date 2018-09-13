# Functions to load and print out the clawpack output
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

module Claw

using Statistics: mean
using DelimitedFiles: readdlm
using Printf
using Dates

include("DefStructs.jl")
include("Data.jl")
include("Utils.jl")
include("LoadTopo.jl")
include("LoadFort.jl")
include("LoadGauge.jl")

using Plots
pyplot()
include("PlotTools.jl")

end
