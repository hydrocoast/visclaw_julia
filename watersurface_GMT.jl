include("./addpath.jl")
using Claw


# -----------------------------
# chile 2010
# -----------------------------
# load configurations
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
# load water surface
amrall = Claw.LoadSurface(simdir, 2:3)

# makegrd
G = Claw.tilegrd.(amrall.amr[2])
#=
# makecpt
GMT.gmt("makecpt -Cpolar -D -T-1.0/1.0 > tmp.cpt")
cpt = GMT.gmt("read -Tc tmp.cpt")
rm("tmp.cpt")
=#
# plot

# -----------------------------


#=
# -----------------------------
# ike
# -----------------------------
# load configurations
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")

# load water surface
amrall = Claw.LoadSurface(simdir)

# plot
Claw.GMTSurfaceAll(amrall, figinfo, cptinfo, outinfo=outinfo,
                   coastinfo=coastinfo, timeinfo=timeinfo)
# -----------------------------
=#
