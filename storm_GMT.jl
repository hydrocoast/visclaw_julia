include("./addpath.jl")
using Claw

using Printf
using GMT: GMT

using Dates: Dates
timeorigin = Dates.DateTime(2008, 9, 13, 7)

# arrow style
arrow = "0.01/0.15/0.05" # -A (LineWidth,  HeadLength, HeadSize)
vscale = "e0.03/0.0/12"  # -Se <velscale> / <confidence> / <fontsize>
arrow_color = "black"
scalefile = Claw.txtwind_scale(-92.5, 30.0, 30.0, 0.0)

# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")

# makecpt
#cpt = GMT.makecpt(C=:seis, T="950/1015", D=true)
cpt = GMT.makecpt(C=:wysiwyg, T="950/1020", D=true, I=true)

# load
amrall = Claw.LoadStorm(simdir)
Claw.RemoveCoarseUV!.(amrall.amr)

# projection and region GMT
region = Claw.getR(amrall.amr[1])
proj = Claw.getJ("X10d", Claw.axesratio(amrall.amr[1]))

time_dates = timeorigin .+ Dates.Second.(amrall.timelap)
time_str = Dates.format.(time_dates,"yyyy/mm/dd_HH:MM")



for i = 1:amrall.nstep
    outps = "fig/storm_step"*@sprintf("%03d", i)*".ps"

    # land-masked surface grids
    G = Claw.tilegrd.(amrall.amr[i]; spacing_unit="d")

    # surface grids without
    GMT.basemap(J=proj, R=region, B="+t"*time_str[i])
    GMT.grdimage!.(G, C=cpt, J=proj, R=region, B="", Q=true)
    GMT.colorbar!(J=proj, R=region, B="xa10f10 y+lhPa", D="jBR+w8.0/0.3+o-1.5/0.0")
    GMT.coast!(J=proj, R=region, B="a10f10 neSW", D=:i, W="thinnest,gray80")

    # wind field
    psfile = GMT.fname_out(Dict())[1]
    velofile = Claw.txtwind(amrall.amr[i], skip=3)
    GMT.gmt("psvelo $velofile -J$proj -R$region -G$arrow_color -A$arrow -S$vscale -P -K -O >> $psfile ")
    rm(velofile, force=true)
    GMT.gmt("psvelo $scalefile -J$proj -R$region -G$arrow_color -A$arrow -S$vscale -Y1.2d -P -O >> $psfile ")

    # save
    cp(GMT.fname_out(Dict())[1], outps, force=true)
end

rm(scalefile, force=true)
