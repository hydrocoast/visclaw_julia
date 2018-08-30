# Functions to load and print out the clawpack output
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

module AMR

using Statistics: mean
using Printf

include("DefStructs.jl")
include("Range.jl")
include("LoadAscii.jl")

using Plots
gr()
include("PlotTools.jl")

end
