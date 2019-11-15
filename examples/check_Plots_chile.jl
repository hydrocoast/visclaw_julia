using VisClaw

using Printf
using Plots
gr()
#plotlyjs()

# easy checker
# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(VisClaw.CLAW, "geoclaw/examples/tsunami/chile2010/_output")

# sea surface height
plt = VisClaw.PlotsCheck(simdir; color=:balance, clims=(-0.5,0.5))

# velocity
#plt = VisClaw.PlotsCheck(simdir; vartype="current", color=:isolum, clims=(0.0,0.1))
# -----------------------------
