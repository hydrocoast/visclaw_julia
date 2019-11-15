using Claw

### Seafloor deformation (for tsunami simulation)
using Plots
gr()

# -----------------------------
# chile 2010
# -----------------------------
# load
simdir = joinpath(Claw.CLAW, "geoclaw/examples/tsunami/chile2010/_output")
dtopofile, ntopo = Claw.dtopodata(simdir)
dtopo = Claw.LoadDeform(dtopofile)

# plot
plt = Claw.PlotsTopo(dtopo; linetype=:contourf,
                     color=:coolwarm, clims=(-3.0,3.0))
Plots.savefig(plt, "chile_dtopo.svg")
# -----------------------------
