include("./addpath.jl")
using Claw

using Printf
using GMT: GMT


# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")

# load topo
topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)
Δtopo = (topo.x[end]-topo.x[1])/(topo.ncols-1)

# makecpt
cpt = GMT.makecpt(C=:jet, T="0.0/2.0", D=true, V=true)

# load water surface
amrall = Claw.LoadSurface(simdir)

# projection and region GMT
region = Claw.getR(amrall.amr[1])
proj = Claw.getJ("X10d", Claw.axesratio(amrall.amr[1]))

# masking
landmask_txt = Claw.landmask_asc(topo)
#Gland = Claw.landmask_grd(landmask_txt, R=region, I=Δtopo, S="$(sqrt(2)Δtopo)d")

for i = 1:amrall.nstep
    timestr = "+t"*@sprintf("%d", amrall.timelap[i]/3.6e3)
    outps = "fig/surf_step"*@sprintf("%03d", i)*".ps"

    # land-masked surface grids
    G = Claw.tilegrd_mask.(amrall.amr[i], landmask_txt; spacing_unit="d")

    # plot
    GMT.basemap(J=proj, R=region, B=timestr)
    #GMT.grdimage!(Gland, R=region, J=proj, C="white,gray", Q=true)
    GMT.grdimage!.(G, C=cpt, J=proj, R=region, B="", Q=true)
    GMT.colorbar!(J=proj, R=region, B="xa0.5f0.25 y+l(m)", D="jBR+w8.0/0.3+o-1.5/0.0", V=true)
    GMT.coast!(J=proj, R=region, B="a10f10 neSW", D=:i, W=:thinnest, V=true)

    # save
    cp(GMT.fname_out(Dict())[1], outps, force=true)
end
# -----------------------------
