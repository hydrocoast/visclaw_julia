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
plt = Claw.PlotsTopo(topo; linetype=:heatmap,
                     color=:delta, clims=(-5000,5000))
plt = Claw.PlotsTopo!(plt, topo; linetype=:contour, fill=false, lc=:black, levels=[0])

# save
Plots.savefig(plt, "fig/chile2010_topo.svg")
# -----------------------------
