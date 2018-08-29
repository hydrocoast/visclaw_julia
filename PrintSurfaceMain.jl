# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

if !(@isdefined AMR)
    include("src/AMR.jl")
end

## variable to load (default: η)
# 1:h, 2:hu, 3:hv, 4:η
#col_num = 4

## input
## output (default: "./fig")
## chile2010
#=
fdir = "../miyaclaw/chile2010/_output"
outdir = "./fig/chile2010"
xl=(-120.0,-60.0)
yl=(-60.0, 0.0)
cl=(-0.5, 0.5)
cpt=:coolwarm
=#


## ike
fdir = "../miyaclaw/ike/_output"
outdir = "./fig/ike"
xl=(-99.0,-70.0)
yl=(8.0, 32.0)
cl=(0.0, 2.0)
cpt=:coolwarm


amrall = AMR.Load(fdir);
plt = AMR.PlotTimeSeries(amrall, tile=true, ann=true, xlim=xl, ylim=yl, clim=cl, cmap=cpt);
AMR.PrintPlots(plt, outdir);

#=
## tmp
fdir = "../miyaclaw/ex_ss/_output"
outdir = "./fig/ex"
cpt=:coolwarm

## Plot the time-series of $(col_num)
include("./AMRPlot.jl")
plt = PlotTimeSeries(amrall, cpt, tile=false, ann=false);

## Print out
if !isdir(outdir); mkdir(outdir); end
for i = 1:length(plt)
    if (@isdefined xl); plot(plt[i], xlims=xl); end
    if (@isdefined yl); plot(plt[i], ylims=yl); end
    if (@isdefined cl); plot(plt[i], clims=cl); end
    savefig(plt[i], joinpath(outdir, "step"*Printf.@sprintf("%03d",i-1)*".svg"))
end

#################
### Main Topo ###
#################
fdir = "../miyaclaw/ex_ss/bathy"
fname = "sampleGEBCO.asc"

topo, nrow, ncol, xll, yll = readtopo(joinpath(fdir,fname))


#=
import Plots
Plots.gr()

Plots.plot(0:ncols-1, 0:nrows-1, topo, linetype=:contour, fill=true, ratio=:equal, clims=(-6000, 5000), color=:pu_or, levels=11)
=#
=#
