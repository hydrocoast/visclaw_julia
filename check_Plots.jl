include("./addpath.jl")
using Claw

using Plots:Plots
Plots.plotlyjs()

# easy checker

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(Claw.CLAW, "geoclaw/examples/tsunami/chile2010/_output")
conffile = "./ex_conf/conf_plots_chile.jl"
plt = Claw.PlotsCheck(simdir, conffile)
# -----------------------------


#=
# -----------------------------
# ike
# -----------------------------
simdir = joinpath(Claw.CLAW, "geoclaw/examples/storm-surge/ike/_output")
conffile = "./ex_conf/conf_plots_ike.jl"
plt = Claw.PlotsCheck(simdir, conffile)
plt = Claw.PlotsCheck(simdir, conffile, vartype="storm")
# -----------------------------
=#
