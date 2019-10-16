include("./addpath.jl")
using Claw


# -----------------------------
# chile 2010
# -----------------------------
# load configurations
figinfo, cptinfo, outinfo, coastinfo, timeinfo = Claw.GMTSurfaceConf("./ex_conf/conf_gmtsurf_chile.jl")

# load water surface
amrall = Claw.LoadSurface(figinfo.dir)

# plot
Claw.GMTSurfaceAll(amrall, figinfo, cptinfo, outinfo=outinfo,
                   coastinfo=coastinfo, timeinfo=timeinfo)
# -----------------------------


#=
# -----------------------------
# ike
# -----------------------------
# load configurations
figinfo, cptinfo, outinfo, coastinfo, timeinfo = Claw.GMTSurfaceConf("./ex_conf/conf_gmtsurf_ike.jl")

# load water surface
amrall = Claw.LoadSurface(figinfo.dir)

# plot
Claw.GMTSurfaceAll(amrall, figinfo, cptinfo, outinfo=outinfo,
                   coastinfo=coastinfo, timeinfo=timeinfo)
# -----------------------------
=#
