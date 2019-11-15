using Claw

using Plots
gr()
#plotlyjs()

# easy checker
# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(Claw.CLAW, "geoclaw/examples/tsunami/chile2010/_output")

# sea surface height
plt = Claw.PlotsCheck(simdir; color=:balance, clims=(-0.5,0.5))

# velocity
#plt = Claw.PlotsCheck(simdir; vartype="current", color=:isolum, clims=(0.0,0.1))
# -----------------------------
