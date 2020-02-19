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
topo = VisClaw.loadtopo(simdir)

# plot
plt = VisClaw.plotstopo(topo; linetype=:heatmap, color=:delta, clims=(-5000,5000))
plt = VisClaw.plotstopo!(plt, topo; linetype=:contour, fill=false, lc=:black, levels=[0])

# save
Plots.savefig(plt, "chile2010_topo.svg")
# -----------------------------
