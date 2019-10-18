include("./addpath.jl")
using Claw


# -----------------------------
# ike
# -----------------------------
# load configurations
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
conffile = "./ex_conf/conf_gmtstorm_ike.jl"
figinfo, cptinfo, outinfo, coastinfo, ctrinfo, arwinfo, timeinfo = Claw.GMTStormConf(conffile)

# load
amrall = Claw.LoadStorm(simdir)
Claw.RemoveCoarseUV!.(amrall.amr)

# plot
Claw.GMTStormAll(amrall, figinfo, cptinfo, outinfo=outinfo,
                 coastinfo=coastinfo, timeinfo=timeinfo, arwinfo=arwinfo, ctrinfo=ctrinfo)
# -----------------------------
