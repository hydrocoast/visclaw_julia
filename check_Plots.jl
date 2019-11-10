include("./addpath.jl")
using Claw

using Plots:Plots
Plots.gr()

# easy checker
# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(Claw.CLAW, "geoclaw/examples/tsunami/chile2010/_output")
plt = Claw.PlotsCheck(simdir; color=:balance, clims=(-0.5,0.5))
#plt = Claw.PlotsCheck(simdir; vartype="current", color=:isolum, clims=(0.0,0.1))
# -----------------------------


#=
# -----------------------------
# ike
# -----------------------------
simdir = joinpath(Claw.CLAW, "geoclaw/examples/storm-surge/ike/_output")

# sea surface height
#plt = Claw.PlotsCheck(simdir; color=:darkrainbow, clims=(-0.5,2.0))

# pressure
Plots.plotlyjs()
plt = Claw.PlotsCheck(simdir; vartype="storm", color=:heat_r, clims=(960,1010))
# -----------------------------
=#
