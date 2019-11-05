include("./addpath.jl")
using Claw


# -----------------------------
# Chile 2010
# -----------------------------
#simdir = "/mnt/HDD8TB/00_PhD/00_Research/AMR/miyaclaw/chile2010_fgmax/_output"

# load
fg = Claw.FGmaxData(simdir)
fg = Claw.LoadFGmaxGrid.(fg)
fgmax = Claw.LoadFGmax.(simdir, fg, nval_save=5)

# plot
#plt = Claw.PlotsFGmax(fg[1], fgmax[1], :h; clims=(0.0, 5000), axis_ratio=:equal)
#pltth = Claw.PlotsFGmax(fg[1], fgmax[1], :th; axis_ratio=:equal)
pltv = Claw.PlotsFGmax(fg[1], fgmax[1], :v; axis_ratio=:equal, color=:bkr, clims=(0.0,1.0))
