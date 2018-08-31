# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

if !(@isdefined AMR)
    include("src/AMR.jl")
end

## variable to load (default: η)
# 1:h, 2:hu, 3:hv, 4:η
#col_num = 4

using Plots

## input
## output (default: "./fig")
## chile2010
fdir = "../clawpack-5.4.1/geoclaw/examples/tsunami/chile2010/_output"
outdir = "./fig/chile2010"
cl=(-0.5, 0.5)
cpt=:coolwarm

amrall = AMR.LoadSurface(fdir);
plt = AMR.PlotTimeSeries(amrall, clim=cl, cmap=cpt);
AMR.PrintPlots(plt, outdir);

#=
## ike
fdir = "../clawpack-5.4.1/geoclaw/examples/storm-surge/ike/_output"
outdir = "./fig/ike"
cl=(0.0, 2.0)
Plots.clibrary(:misc)
cpt=:lightrainbow

amrall = AMR.LoadSurface(fdir);
plt = AMR.PlotTimeSeries(amrall, bound=true, gridnumber=true, clim=cl, cmap=cpt);
AMR.PrintPlots(plt, outdir);
=#
