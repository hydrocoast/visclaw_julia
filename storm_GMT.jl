include("./addpath.jl")
using Claw


# -----------------------------
# ike
# -----------------------------
# load configurations
figinfo, cptinfo, outinfo, coastinfo, ctrinfo, arwinfo, timeinfo = Claw.GMTStormConf("./ex_conf/conf_gmtstorm_ike.jl")

# load
amrall = Claw.LoadStorm(figinfo.dir)
Claw.RemoveCoarseUV!.(amrall.amr)

# plot
Claw.GMTStormAll(amrall, figinfo, cptinfo, outinfo=outinfo,
                 coastinfo=coastinfo, timeinfo=timeinfo, arwinfo=arwinfo, ctrinfo=ctrinfo)
# -----------------------------
