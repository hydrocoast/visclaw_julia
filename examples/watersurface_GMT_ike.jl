using VisClaw

using Printf
using GMT: GMT

# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
output_prefix = "ike_eta_GMT"
using Dates: Dates
timeorigin = Dates.DateTime(2008, 9, 13, 7)

# load topo
topo = VisClaw.LoadTopo(simdir)

# makecpt
cpt = GMT.makecpt(C=:jet, T="0.0/2.0", D=true, V=true)

# load water surface
amrall = VisClaw.LoadSurface(simdir)

# projection and region GMT
region = VisClaw.getR(amrall.amr[1])
proj = VisClaw.getJ("X10d", VisClaw.axesratio(amrall.amr[1]))

# masking
landmask_txt = VisClaw.landmask_asc(topo)
#Gland = VisClaw.landmask_grd(landmask_txt, R=region, I=topo.dx, S="$(sqrt(2.0)topo.dx)d")

# time in string
time_dates = timeorigin .+ Dates.Second.(amrall.timelap)
time_str = Dates.format.(time_dates,"yyyy/mm/dd_HH:MM")

for i = 1:amrall.nstep
    outps = output_prefix*@sprintf("%03d", i)*".ps"

    # land-masked surface grids
    G = VisClaw.tilegrd_mask.(amrall.amr[i], landmask_txt; spacing_unit="d")

    # plot
    GMT.basemap(J=proj, R=region, B="+t"*time_str[i])
    #GMT.grdimage!(Gland, R=region, J=proj, C="white,gray80", Q=true)
    GMT.grdimage!.(G, C=cpt, J=proj, R=region, B="", Q=true)
    GMT.colorbar!(J=proj, R=region, B="xa0.5f0.25 y+l(m)", D="jBR+w8.0/0.3+o-1.5/0.0", V=true)
    GMT.coast!(J=proj, R=region, B="a10f10 neSW", D=:i, W=:thinnest, V=true)

    # save
    cp(GMT.fname_out(Dict())[1], outps, force=true)
end

rm(landmask_txt, force=true)

# gif
VisClaw.GMTps2gif(output_prefix, amrall.nstep)
# -----------------------------
