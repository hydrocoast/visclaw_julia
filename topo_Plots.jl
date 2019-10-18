include("./addpath.jl")
using Claw

### Topography and bathymetry

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
conffile = "./ex_conf/conf_plots_chile.jl"
pltinfo, axinfo, outinfo = Claw.PlotsTopoConf(conffile)
# Plot
plt, topo = Claw.PlotsTopo(simdir, pltinfo, axinfo, outinfo)
# -----------------------------


# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
conffile = "./ex_conf/conf_plots_ike.jl"
pltinfo, axinfo, outinfo = Claw.PlotsTopoConf(conffile)
# Plot
plt, topo = Claw.PlotsTopo(simdir, pltinfo, axinfo, outinfo)
# -----------------------------
