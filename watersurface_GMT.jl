include("./addpath.jl")
using Claw


# -----------------------------
# chile 2010
# -----------------------------
# load configurations
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
conffile = "./ex_conf/conf_gmtsurf_chile.jl"
figinfo, cptinfo, outinfo, coastinfo, timeinfo = Claw.GMTSurfaceConf(conffile)

# load water surface
amrall = Claw.LoadSurface(simdir)

# plot
Claw.GMTSurfaceAll(amrall, figinfo, cptinfo, outinfo=outinfo,
                   coastinfo=coastinfo, timeinfo=timeinfo)
# -----------------------------



# -----------------------------
# ike
# -----------------------------
# load configurations
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
conffile = "./ex_conf/conf_gmtsurf_ike.jl"
figinfo, cptinfo, outinfo, coastinfo, timeinfo = Claw.GMTSurfaceConf(conffile)

# load water surface
amrall = Claw.LoadSurface(simdir)

# plot
Claw.GMTSurfaceAll(amrall, figinfo, cptinfo, outinfo=outinfo,
                   coastinfo=coastinfo, timeinfo=timeinfo)
# -----------------------------
