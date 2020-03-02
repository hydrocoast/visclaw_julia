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
topo = loadtopo(simdir)

# plot
plt = plotstopo(topo; linetype=:heatmap, color=:delta, clims=(-5000,5000))
plt = plotscoastline!(plt, topo; lc=:black)

# save
savefig(plt, "chile2010_topo.svg")
# -----------------------------
