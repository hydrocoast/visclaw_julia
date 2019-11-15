using VisClaw
using Printf
using GMT: GMT

# -----------------------------
# ike
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
topofile, ntopo = VisClaw.topodata(simdir)
topo = VisClaw.LoadTopo(topofile)

# makegrd
G = VisClaw.geogrd(topo; V=true)
# makecpt
cpt = GMT.makecpt(; C=:earth, T="-7000/4500", D=true)

# plot
region = VisClaw.getR(topo)
proj = VisClaw.getJ("X10d", VisClaw.axesratio(topo))
GMT.grdimage(G, C=cpt, J=proj, R=region, B="a10f10 neSW", Q=true, V=true)
GMT.colorbar!(J=proj, R=region, B="xa2000f1000 y+l\"(m)\"", D="jBR+w5.5/0.2+o-1.0/-0.5", V=true)
GMT.coast!(J=proj, R=region, D=:i, W=:thinnest, V=true)

# save
cp(GMT.fname_out(Dict())[1], "ike_topo.ps", force=true)
# -----------------------------
