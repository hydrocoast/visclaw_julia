# topography image with GMT
if !(@isdefined CLAW); include("./CLAWPATH.jl"); end
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

## file paths
fdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
#Bopt="a15f15 neSW"
#Bcb="a1000f500/:\"(m)\":"

# load
topofile, _ = Claw.topodata(fdir)
geo = Claw.LoadTopo(topofile);
# output
Claw.GMTTopo(geo,"./tmp_topo1.png", coast=true)


## file paths
fdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
Bopt="a10f10 neSW"
Bcb="a2000f1000/:\"(m)\":"

# load
topofile, _ = Claw.topodata(fdir)
geo = Claw.LoadTopo(topofile);
# output
Claw.GMTTopo(geo,"./tmp_topo2.png", B=Bopt, Bcb=Bcb, coast=true)
