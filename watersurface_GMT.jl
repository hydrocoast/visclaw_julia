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

xv = vec(repeat(topo.x, inner=(topo.nrows,1)));
yv = vec(repeat(topo.y, outer=(topo.ncols,1)));
topov = vec(topo.topo);

inds = topov .< 0.0 # ocean
deleteat!(xv, inds)
deleteat!(yv, inds)
deleteat!(topov, inds)

open("topo4mask.txt","w") do file
    Base.print_array(file, [xv yv topov])
end

Δ = (topo.x[end]-topo.x[1])/(topo.ncols-1)
#Gmask = GMT.mask([xv yv topov], R=region, I=Δ, S=Δ, N="0/0/NaN")
GMT.gmt("grdmask topo4mask.txt -R$region -I$Δ -N0/0/NaN -S$(Δ)d -Gtopomask.grd -V")


# makegrd
xv, yv, zv = Claw.UniqueMeshVector(amrall.amr[1])
Δ = min( minimum(getfield.(amrall.amr[1], :dx)),
         minimum(getfield.(amrall.amr[1], :dy)))
#GMT.surface([xv yv zv], R=region, I=Δ, G="eta.grd")
GMT.nearneighbor([xv yv zv], R=region, I=Δ, S="$(Δ)d", G="eta.grd")

GMT.gmt("grdmath eta.grd topomask.grd OR = etamasked.grd")

G = GMT.gmt("read -Tg etamasked.grd")

#G = Claw.tilegrd.(amrall.amr[1])

# makecpt
GMT.gmt("makecpt -Cpolar -D -T-1.0/1.0 > tmp.cpt")
cpt = GMT.gmt("read -Tc tmp.cpt")
rm("tmp.cpt")
# plot
GMT.basemap(J=proj, R=region, B="a15f15 neSW")
GMT.grdimage!(G, C=cpt, J=proj, R=region)
#GMT.grdimage!(G, C=cpt, J=proj, R=region, Q=true)
#= =#
#GMT.grdimage(G, C=cpt, J=proj, R=region, V=true)
#GMT.colorbar!(J=proj, R=region, B="a0.5f0.5/:\"(m)\":", D="jBR+w10.0/0.3+o-1.5/0.0", V=true)
#GMT.coast!(J=proj, R=region, D=:i, W=:thinnest, V=true)
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
