using Claw

### Topography and bathymetry
using Plots
gr()

# -----------------------------
# ike
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)

# Plot
plt = Claw.PlotsTopo(topo; linetype=:heatmap,
                     color=:delta, clims=(-6000,6000))
# save
Plots.savefig(plt, "fig/ike_topo.svg")
# -----------------------------
