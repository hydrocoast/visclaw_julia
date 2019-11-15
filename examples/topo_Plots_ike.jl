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
plt = Claw.PlotsTopo!(plt, topo; linetype=:contour, fill=false, lc=:black, levels=[0])

# save
Plots.savefig(plt, "ike_topo.svg")
# -----------------------------
