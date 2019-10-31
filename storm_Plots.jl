include("./addpath.jl")
using Claw

using Plots
pyplot()

# -----------------------------
# ike
# -----------------------------
# load configurations
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
conffile = "./ex_conf/conf_plots_ike.jl"
pltinfo, axinfo, outinfo = Claw.PlotsStormConf(conffile)

# load
amrall = Claw.LoadStorm(simdir, 5:6)
Claw.RemoveCoarseUV!.(amrall.amr)

# plot
plts = Claw.PlotsStormAll(amrall, pltinfo, axinfo)
plts = [Claw.PlotsWindArrow!(plts[i], amrall.amr[i], 3) for i = 1:amrall.nstep]
# -----------------------------
