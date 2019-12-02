using VisClaw
using Printf

### Topography and bathymetry
using Plots
gr()

# -----------------------------
# chile 2010
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
topofile, topotype, ntopo = VisClaw.topodata(simdir)
topo = VisClaw.LoadTopo(topofile, topotype)

# plot
plt = VisClaw.PlotsTopo(topo; linetype=:heatmap, color=:delta, clims=(-5000,5000))
plt = VisClaw.PlotsTopo!(plt, topo; linetype=:contour, fill=false, lc=:black, levels=[0])

# save
Plots.savefig(plt, "chile2010_topo.svg")
# -----------------------------
