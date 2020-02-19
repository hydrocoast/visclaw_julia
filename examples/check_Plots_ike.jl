using VisClaw

using Printf
using Plots
gr()
#plotlyjs()

# easy checker
# -----------------------------
# ike
# -----------------------------
simdir = joinpath(VisClaw.CLAW, "geoclaw/examples/storm-surge/ike/_output")

# sea surface height
#plt = VisClaw.plotscheck(simdir; color=:darkrainbow, clims=(-0.5,2.0))

# pressure
plt = VisClaw.plotscheck(simdir; vartype="storm", color=:heat_r, clims=(960,1010))
# -----------------------------
