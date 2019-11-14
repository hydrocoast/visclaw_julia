using Claw

### Topography and bathymetry
using Plots
gr()

# -----------------------------
# chile 2010
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)

# plot
plt = Claw.PlotsTopo(topo; linetype=:contourf,
                     color=:delta, clims=(-6000,6000))
# save
Plots.savefig(plt, "fig/chile2010_topo.svg")
# -----------------------------
