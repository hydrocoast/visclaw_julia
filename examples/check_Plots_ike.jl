using Claw

using Plots
gr()
#plotlyjs()

# easy checker
# -----------------------------
# ike
# -----------------------------
simdir = joinpath(Claw.CLAW, "geoclaw/examples/storm-surge/ike/_output")

# sea surface height
#plt = Claw.PlotsCheck(simdir; color=:darkrainbow, clims=(-0.5,2.0))

# pressure
plt = Claw.PlotsCheck(simdir; vartype="storm", color=:heat_r, clims=(960,1010))
# -----------------------------
