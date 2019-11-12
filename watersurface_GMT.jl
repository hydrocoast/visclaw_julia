include("./addpath.jl")
using Claw

using GMT: GMT

# -----------------------------
# chile 2010
# -----------------------------
# load configurations
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")

topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)

# load water surface
amrall = Claw.LoadSurface(simdir, 2:3)

region = Claw.getR(amrall.amr[1])
proj = Claw.getJ("X10d", Claw.axesratio(amrall.amr[1]))


landmask_txt = Claw.landmask_asc(topo)
G = Claw.tilegrd_mask.(amrall.amr[1], landmask_txt; spacing_unit="d")

# makecpt
GMT.gmt("makecpt -Cpolar -D -T-1.0/1.0 > tmp.cpt")
cpt = GMT.gmt("read -Tc tmp.cpt")
rm("tmp.cpt")
# plot
GMT.basemap(J=proj, R=region, B="a15f15 neSW")
GMT.grdimage!.(G, C=cpt, J=proj, R=region, B="", Q=true)
GMT.colorbar!(J=proj, R=region, B="a0.5f0.5/:\"(m)\":", D="jBR+w10.0/0.3+o-1.5/0.0", V=true)
GMT.coast!(J=proj, R=region, B="", D=:i, W=:thinnest, V=true)
# -----------------------------


#=
tmp
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
