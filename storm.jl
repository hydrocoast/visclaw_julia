# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

#if !(@isdefined Claw)
    include("src/Claw.jl")
#end
## ike
fdir = "../clawpack-5.4.1/geoclaw/examples/storm-surge/ike/_output"
outdir = "./fig/ike"

using Plots
pyplot()
Plots.clibrary(:misc)

storm = Claw.LoadStorm(fdir);
plt = Claw.PlotTimeSeries(storm,var=:slp, cmap=:heat_r);
plt = Claw.PlotWindField!(plt, storm, 5, len=0.05)
Claw.PrintPlots(plt, outdir, prefix="slp");
