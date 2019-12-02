using VisClaw
using Printf

### Seafloor deformation (for tsunami simulation)
using Plots
gr()

# -----------------------------
# chile 2010
# -----------------------------
# load
simdir = joinpath(VisClaw.CLAW, "geoclaw/examples/tsunami/chile2010/_output")
dtopo = VisClaw.LoadDeform(simdir)

# plot
plt = VisClaw.PlotsTopo(dtopo; linetype=:contourf,
                     color=:coolwarm, clims=(-3.0,3.0))
Plots.savefig(plt, "chile_dtopo.svg")
# -----------------------------
