include("./addpath.jl")
using Claw

# topography image using GMT
using GMT: GMT

# -----------------------------
# chile 2010
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)

# makegrd
G = Claw.geogrd(topo; V=true)
# makecpt
cpt = GMT.makecpt(; C=:earth, T="-7000/4500", D="i")

# plot
region = Claw.geoR(topo)
proj = Claw.geoJ(topo, proj_base="X10d")
GMT.grdimage(G, C=cpt, J=proj, R=region, B="a15f15 neSW", Q=true, V=true)
GMT.colorbar!(J=proj, R=region, B="a1000f500/:\"(m)\":", D="jBR+w10.0/0.3+o-1.5/0.0", V=true)
GMT.coast!(J=proj, R=region, D=:i, W=:thinnest, V=true)

# save
cp(GMT.fname_out(Dict())[1], "fig/chile2010_topo.ps", force=true)
# -----------------------------


#=
# -----------------------------
# ike
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
topofile, ntopo = Claw.topodata(simdir)
topo = Claw.LoadTopo(topofile)

# makegrd
G = Claw.geogrd(topo; V=true)
# makecpt
cpt = GMT.makecpt(; C=:earth, T="-7000/4500", D="i")

# plot
region = Claw.geoR(topo)
proj = Claw.geoJ(topo, proj_base="X10d")
GMT.grdimage(G, C=cpt, J=proj, R=region, B="a10f10 neSW", Q=true, V=true)
GMT.colorbar!(J=proj, R=region, B="a2000f1000/:\"(m)\":", D="jBR+w5.5/0.2+o-1.0/-0.5", V=true)
GMT.coast!(J=proj, R=region, D=:i, W=:thinnest, V=true)

# save
cp(GMT.fname_out(Dict())[1], "fig/ike_topo.ps", force=true)
# -----------------------------
=#
