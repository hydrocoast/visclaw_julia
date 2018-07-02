# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018
### Plot
using Plots
gr()
clibrary(:colorcet)

## vartype definition
if !isdefined(:AMR)
    include("./AMRStruct.jl")
end
## variable to load (default: η)
# 1:h, 2:hu, 3:hv, 4:η
#col_num = 4

## input
## output (default: "./fig")
## chile2010
fdir = "../chile2010/_output"
outdir = "./fig/chile2010"
xl=(-120.0,-60.0)
yl=(-60.0, 0.0)
cl=(-0.5, 0.5)
cpt=:coolwarm
#=
## ike
fdir = "../ike/_output"
outdir = "./fig/ike"
xl=(-99.0,-70.0)
yl=(8.0, 32.0)
cl=(0.0, 2.0)
cpt=:coolwarm
=#

## Read output of the simulation
include("./AMRLoad.jl")
amrall = AMRLoad(fdir);

## Plot the time-series of $(col_num)
include("./AMRPlot.jl")
plt = PlotTimeSeries(amrall, cpt, tile=true, ann=false);

## Print out
if !isdir(outdir); mkdir(outdir); end
for i = 1:length(plt)
    if isdefined(:xl); plot(plt[i], xlims=xl); end
    if isdefined(:yl); plot(plt[i], ylims=yl); end
    if isdefined(:cl); plot(plt[i], clims=cl); end
    savefig(plt[i], joinpath(outdir, "step"*@sprintf("%03d",i-1)*".svg"))
end
