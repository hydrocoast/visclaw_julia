using Claw

# topography image using GMT
using GMT: GMT

# -----------------------------
# chile 2010
# -----------------------------
# load
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
dtopofile, ntopo = Claw.dtopodata(simdir)
dtopo = Claw.LoadDeform(dtopofile)

# makegrd
G = Claw.geogrd(dtopo; V=true)
# makecpt
cpt = GMT.makecpt(; C=:polar, T="-1.0/1.0", D=true)

# plot
region = Claw.getR(dtopo)
proj = Claw.getJ("X10d", Claw.axesratio(dtopo))

GMT.grdimage(G, C=cpt, J=proj, R=region, B="a5f5 neSW", Q=true, V=true)
GMT.colorbar!(J=proj, R=region, B="xa0.5f0.5 y+l\"(m)\"", D="jBR+w10.0/0.3+o-1.5/0.0", V=true)
GMT.coast!(J=proj, R=region, D=:i, W=:thinnest, V=true)

# save
cp(GMT.fname_out(Dict())[1], "fig/chile2010_dtopo.ps", force=true)
# -----------------------------
