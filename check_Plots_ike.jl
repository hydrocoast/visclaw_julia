using Claw

using Plots:Plots

# easy checker
# -----------------------------
# ike
# -----------------------------
simdir = joinpath(Claw.CLAW, "geoclaw/examples/storm-surge/ike/_output")

# sea surface height
#Plots.gr()
#plt = Claw.PlotsCheck(simdir; color=:darkrainbow, clims=(-0.5,2.0))

# pressure
Plots.plotlyjs()
plt = Claw.PlotsCheck(simdir; vartype="storm", color=:heat_r, clims=(960,1010))
# -----------------------------
