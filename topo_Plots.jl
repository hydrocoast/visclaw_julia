include("./addpath.jl")
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

plt = Claw.PlotsTopo(topo; color=:delta, clims=(-6000,6000), linetype=:contourf)
#Plots.savefig(plt, "fig/topoplots_chile.svg")
# -----------------------------

#=
# -----------------------------
# ike
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)

# Plot
plt = Claw.PlotsTopo(topo; color=:delta, clims=(-6000,6000), linetype=:heatmap)
#Plots.savefig(plt, "fig/topoplots_ike.svg")
# -----------------------------
=#
