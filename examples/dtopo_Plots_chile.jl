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
dtopo = VisClaw.loaddeform(simdir)

# plot
plt = VisClaw.plotstopo(dtopo; linetype=:contourf,
                     color=:coolwarm, clims=(-3.0,3.0))
Plots.savefig(plt, "chile_dtopo.svg")
# -----------------------------
