# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

#if !(@isdefined AMR)
    include("src/AMR.jl")
#end

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
fdir = "../clawpack-5.4.1/geoclaw/examples/storm-surge/ike/_output"
outdir = "./fig/ike"
#xl=(-99.0,-70.0)
#yl=(8.0, 32.0)
cl=(0.0, 2.0)
cpt=:coolwarm


amrall = AMR.LoadSurface(fdir);
plt = AMR.PlotTimeSeries(amrall, tile=true, ann=true, clim=cl, cmap=cpt);
AMR.PrintPlots(plt, outdir);
