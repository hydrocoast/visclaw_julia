include("./addpath.jl")
using Claw

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")

# load configurations
conffile = "./ex_conf/conf_plots_chile.jl"
pltinfo, axinfo, outinfo = Claw.PlotsCurrentConf(conffile)

# load water current
amrall = Claw.LoadCurrent(simdir)

# plot
plts = Claw.PlotsCurrentAll(amrall, pltinfo, axinfo, bound=true, gridnumber=false)
Claw.PrintPlots(plts, outinfo)
# -----------------------------


#=
# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")

# load configurations
conffile = "./ex_conf/conf_plots_ike.jl"
pltinfo, axinfo, outinfo = Claw.PlotsCurrentConf(conffile)

# load water current
amrall = Claw.LoadCurrent(simdir)

# plot
plts = Claw.PlotsCurrentAll(amrall, pltinfo, axinfo, bound=true, gridnumber=true)
Claw.PrintPlots(plts, outinfo)
# -----------------------------
=#
