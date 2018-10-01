# topography image with GMT
if !(@isdefined CLAW)
    include("./CLAWPATH.jl")
end
#if !(@isdefined Claw)
    include("src/Claw.jl")
#end


import GMT
## file paths
fdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
frame="a15f15 neSW"
cbframe="a1000f500/:\"(m)\":"
#=
fdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
frame="a10f10 neSW"
cbframe="a2000f1000/:\"(m)\":"
=#
figw=10;

# load
topofile, _ = Claw.topodata(fdir)
geo = Claw.LoadTopo(topofile);


crange="-7000/4500"
cpt = GMT.gmt("makecpt -Cearth -T$crange -D -V")

xyrange=Claw.geoxyrange(geo)
G = Claw.geogrd(geo)

proj="M$figw"
#frame="a15f15 neSW"
pen="0.05"
GMT.grdimage(G, J=proj, R=xyrange, C=cpt,V=true)
GMT.coast!(J=proj,R=xyrange,B=frame,W=pen,V=true)

figh,figh2 = Claw.axratio(geo,figw)
cbxy="11/$figh2/$figh/0.4"
#cbframe="a1000f500/:\"(m)\":"
GMT.colorbar!(B=cbframe, C=cpt, D=cbxy, V=true)

# output
output="topogmt.png"
Claw.saveaspng(output)
