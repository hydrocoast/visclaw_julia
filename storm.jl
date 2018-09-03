# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

#if !(@isdefined AMR)
    include("src/AMR.jl")
#end
## ike
fdir = "../clawpack-5.4.1/geoclaw/examples/storm-surge/ike/_output"
outdir = "./fig/ike"

using Plots
pyplot()
Plots.clibrary(:misc)

storm = AMR.LoadStorm(fdir);
plt = AMR.PlotTimeSeries(storm,var=:slp, cmap=:heat_r);
plt = AMR.PlotWindField!(plt, storm, 5, len=0.05)
AMR.PrintPlots(plt, outdir, prefix="slp");
