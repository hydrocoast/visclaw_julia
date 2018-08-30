# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

#if !(@isdefined AMR)
    include("src/AMR.jl")
#end

#################
### Main Topo ###
#################
#=
fdir = "../miyaclaw/ex_ss/bathy"
fname = "sampleGEBCO.asc"
=#
fdir = "../clawpack-5.4.1/geoclaw/scratch";
fname = "gulf_caribbean.tt3"

geo = AMR.LoadTopo(joinpath(fdir,fname))

#topo, nrow, ncol, xll, yll = readtopo(joinpath(fdir,fname))
#plt = AMR.PlotTopo(geo)
plt = AMR.CoastalLines(geo)

#=
import Plots
Plots.gr()

Plots.plot(0:ncols-1, 0:nrows-1, topo, linetype=:contour, fill=true, ratio=:equal, clims=(-6000, 5000), color=:pu_or, levels=11)
=#
