# Functions to load and print out the clawpack output
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

module AMR

using Statistics: mean
using DelimitedFiles: readdlm
using Printf

include("DefStructs.jl")
include("Data.jl")
include("Range.jl")
include("LoadTopo.jl")
include("LoadFort.jl")

using Plots
pyplot()
include("PlotTools.jl")

end
