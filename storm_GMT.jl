include("./addpath.jl")
using Claw

using Printf
using GMT: GMT

using Dates: Dates
timeorigin = Dates.DateTime(2008, 9, 13, 7)

# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")

# makecpt
cpt = GMT.makecpt(C=:seis, T="950/1010/5", D=true, R=true)

# load
#amrall = Claw.LoadStorm(simdir)
amrall = Claw.LoadStorm(simdir, 5:6)
Claw.RemoveCoarseUV!.(amrall.amr)

# projection and region GMT
region = Claw.getR(amrall.amr[1])
proj = Claw.getJ("X10d", Claw.axesratio(amrall.amr[1]))

time_dates = timeorigin .+ Dates.Second.(amrall.timelap)
time_str = Dates.format.(time_dates,"yyyy/mm/dd_HH:MM")


i = 1
outps = "fig/storm_step"*@sprintf("%03d", i)*".ps"

# surface grids without
G = Claw.tilegrd.(amrall.amr[i]; spacing_unit="d")
GMT.basemap(J=proj, R=region, B="+t"*time_str[i])
GMT.grdimage!.(G, C=cpt, J=proj, R=region, B="", Q=true)
GMT.colorbar!(J=proj, R=region, B="xa10f10 y+lhPa", D="jBR+w8.0/0.3+o-1.5/0.0", V=true)
GMT.coast!(J=proj, R=region, B="a10f10 neSW", D=:i, W="thinnest,gray80", V=true)

# save
cp(GMT.fname_out(Dict())[1], outps, force=true)

#=
for i = 1:amrall.nstep
    timestr = "+t"*@sprintf("%03d", amrall.timelap[i]/60.0)*"_min"
    outps = "fig/surf_step"*@sprintf("%03d", i)*".ps"

    # land-masked surface grids
    G = Claw.tilegrd_mask.(amrall.amr[i], landmask_txt; spacing_unit="d")

    # plot
    GMT.basemap(J=proj, R=region, B=timestr)
    GMT.grdimage!(Gland, R=region, J=proj, C="white,gray80", Q=true)
    GMT.grdimage!.(G, C=cpt, J=proj, R=region, B="", Q=true)
    GMT.colorbar!(J=proj, R=region, B="xa0.5f0.5 y+l(m)", D="jBR+w10.0/0.3+o-1.5/0.0", V=true)
    GMT.coast!(J=proj, R=region, B="a15f15 neSW", D=:i, W=:thinnest, V=true)

    # save
    cp(GMT.fname_out(Dict())[1], outps, force=true)
end
=#
