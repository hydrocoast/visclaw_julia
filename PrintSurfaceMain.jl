# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018
### Plot
using Plots
gr()
clibrary(:colorcet)

## include functions
include("./loadq.jl")

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

## Plot the time-series of $(col_num)
amr, plt, nfile = PlotTimeSeries(fdir, cpt, tile=true, ann=true);

## Print out
if !isdir(outdir); mkdir(outdir); end
for i = 1:nfile
    plot(plt[i], xlims=xl, ylims=yl, clims=cl)
    savefig(plt[i], joinpath(outdir, "step"*@sprintf("%03d",i-1)*".svg"))
end
