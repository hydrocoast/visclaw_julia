using VisClaw
using Printf
using GMT: GMT

# -----------------------------
# chile2010
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
topo = VisClaw.loadtopo(simdir)

# makegrd
G = VisClaw.geogrd(topo; V=true)
# makecpt
cpt = GMT.makecpt(; C=:earth, T="-7000/4500", D=true)

# plot
region = VisClaw.getR(topo)
proj = VisClaw.getJ("X10d", VisClaw.axesratio(topo))
GMT.grdimage(G, C=cpt, J=proj, R=region, B="a15f15 neSW", Q=true, V=true)
GMT.colorbar!(J=proj, R=region, B="xa1000f1000 y+l\"(m)\"", D="jBR+w10.0/0.3+o-1.2/-0.1", V=true)
GMT.coast!(J=proj, R=region, D=:i, W=:thinnest, V=true, fmt="PDF", savefig="chile2010_topo.pdf")
# -----------------------------
