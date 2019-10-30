include("./addpath.jl")
using Claw

using Plots
plotlyjs()

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")

# load configurations
conffile = "./ex_conf/conf_plots_chile.jl"
pltinfo, axinfo, outinfo = Claw.PlotsSurfaceConf(conffile)

# load water surface
amrall = Claw.LoadSurface(simdir)
# gauge locations (from gauges.data)
gauges = Claw.GaugeData(simdir)

# plot
plts = Claw.PlotsSurfaceAll(amrall, pltinfo, axinfo, bound=true, gridnumber=false)
plts = map(p -> Claw.PlotsGaugeLocation!(p, gauges, ms=4, color=:black), plts)

# save
Claw.PrintPlots(plts, outinfo)
# -----------------------------


#=
# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")

# load configurations
conffile = "./ex_conf/conf_plots_ike.jl"
pltinfo, axinfo, outinfo = Claw.PlotsSurfaceConf(conffile)

# load water surface
amrall = Claw.LoadSurface(simdir)
# gauge locations (from gauges.data)
gauges = Claw.GaugeData(simdir)

# plot
plts = Claw.PlotsSurfaceAll(amrall, pltinfo, axinfo, bound=true, gridnumber=true)
plts = map(p -> Claw.PlotsGaugeLocation!(p, gauges; color=:white), plts)

# save
Claw.PrintPlots(plts, outinfo)
# -----------------------------
=#
