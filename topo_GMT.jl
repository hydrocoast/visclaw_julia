include("./addpath.jl")
using Claw

# topography image with GMT


# -----------------------------
# chile 2010
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)
# config
conffile = "./ex_conf/conf_gmttopo_chile.jl"
topoinfo, cptinfo, outinfo, coastinfo = Claw.GMTTopoConf(conffile)
# Plot
Claw.GMTTopo(topo, topoinfo, cptinfo, outinfo=outinfo, coastinfo=coastinfo)
# -----------------------------


#=
# -----------------------------
# ike
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)
# config
conffile = "./ex_conf/conf_gmttopo_ike.jl"
topoinfo, cptinfo, outinfo, coastinfo = Claw.GMTTopoConf(conffile)
# Plot
Claw.GMTTopo(topo, topoinfo, cptinfo, outinfo=outinfo, coastinfo=coastinfo)
# -----------------------------
=#
