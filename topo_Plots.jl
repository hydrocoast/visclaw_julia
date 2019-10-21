include("./addpath.jl")
using Claw

### Topography and bathymetry

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)
conffile = "./ex_conf/conf_plots_chile.jl"
pltinfo, axinfo, outinfo = Claw.PlotsTopoConf(conffile)
# Plot
plt = Claw.PlotsTopo(topo, pltinfo, axinfo, outinfo)
# -----------------------------

#=
# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)
conffile = "./ex_conf/conf_plots_ike.jl"
pltinfo, axinfo, outinfo = Claw.PlotsTopoConf(conffile)
# Plot
plt = Claw.PlotsTopo(topo, pltinfo, axinfo, outinfo)
# -----------------------------
=#
