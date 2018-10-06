# topography image with GMT
if !(@isdefined CLAW); include("./CLAWPATH.jl"); end
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

## file paths
fdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
B="a15f15 neSW"
Bcb="a1000f500/:\"(m)\":"

# load
topofile, _ = Claw.topodata(fdir)
geo = Claw.LoadTopo(topofile);

# options
J=Claw.geoJ(geo, fwidth=10)
R=Claw.geoR(geo)

# makecpt
cpt = Claw.geocpt()

# draw topogpahy with colors
Claw.GMTTopo(geo, cpt, J=J, R=R, B=B)
# draw coastline
Claw.GMTCoastLine!()

# colorbar option
Dcb = Claw.cboptD(cbx=11, cblen=10)
# set colorbar
Claw.GMTColorbar!(cpt, B=Bcb, D=Dcb)

# output
Claw.saveaseps("tmp_topochile.eps")
