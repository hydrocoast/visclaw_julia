include("./addpath.jl")
using Claw

# -----------------------------
# Chile 2010
# -----------------------------
#simdir = "/mnt/HDD8TB/00_PhD/00_Research/AMR/miyaclaw/chile2010_fgmax/_output"
simdir = "/home/miyashita/Research/AMR/miyaclaw/chile2010_fgmax/_output"

# load
fg = Claw.FGmaxData(simdir)
fg = Claw.LoadFGmaxGrid.(fg)
fgmax = Claw.LoadFGmax.(simdir, fg, nval_save=1)

# plot
#plt = Claw.PlotsFGmax(fg[1], fgmax[1], :h; clims=(0.0, 3.0), axis_ratio=:equal, color=:bkr)
plt = Claw.PlotsFGmax(fg[1], fgmax[1], :h; axis_ratio=:equal, color=:bkr)
#plt = Claw.PlotsFGmax(fg[1], fgmax[1], :h; axis_ratio=:equal)
plt = Claw.PlotsFGmax(fg[1], fgmax[1], :bath; axis_ratio=:equal, color=:delta)
#pltth = Claw.PlotsFGmax(fg[1], fgmax[1], :th; axis_ratio=:equal)
#pltv = Claw.PlotsFGmax(fg[1], fgmax[1], :v; axis_ratio=:equal, color=:bkr, clims=(0.0,1.0))

#=
dat = readdlm(joinpath(simdir,"fort.FG1.aux1"))
npnt, ncol = size(dat)
nlevel = ncol - 2
bath_level = dat[:,3:end]

dat = readdlm(joinpath(simdir,"fort.FG1.valuemax"))
level = convert.(Int64, dat[:,3])
bath = fill(NaN, (npnt,1))
for i = 1:nlevel
  bath[level.==i] .= bath_level[level.==i, 1]
end
=#
