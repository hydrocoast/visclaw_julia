using Claw

using Plots:Plots

# easy checker
# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(Claw.CLAW, "geoclaw/examples/tsunami/chile2010/_output")

# sea surface height
Plots.gr()
plt = Claw.PlotsCheck(simdir; color=:balance, clims=(-0.5,0.5))

# velocity
#plt = Claw.PlotsCheck(simdir; vartype="current", color=:isolum, clims=(0.0,0.1))
# -----------------------------
