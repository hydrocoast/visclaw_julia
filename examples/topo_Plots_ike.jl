using VisClaw
using Printf

### Topography and bathymetry
using Plots
gr()

# -----------------------------
# ike
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
topo = VisClaw.loadtopo(simdir)

# Plot
plt = VisClaw.plotstopo(topo; linetype=:heatmap,
                     color=:delta, clims=(-6000,6000))
plt = VisClaw.plotstopo!(plt, topo; linetype=:contour, fill=false, lc=:black, levels=[0])

# save
Plots.savefig(plt, "ike_topo.svg")
# -----------------------------
