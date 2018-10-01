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

xvec = repeat(geo.x, inner=(geo.nrows,1))
yvec = repeat(geo.y, outer=(geo.ncols,1))
Δ=(geo.x[end]-geo.x[1])/(geo.ncols-1)

xs=geo.x[1]
xe=geo.x[end]
ys=geo.y[1]
ye=geo.y[end]
figh = round(10((ye-ys)/(xe-xs)))/10*figw
figh2=figh/2.

xyrange="$xs/$xe/$ys/$ye"

#G = GMT.gmt("surface -R$xyrange -I$Δ", [xvec[:] yvec[:] geo.topo[:]])
G = GMT.surface([xvec[:] yvec[:] geo.topo[:]], R=xyrange, I=Δ)

proj="M$figw"
#frame="a15f15 neSW"
pen="0.05"
GMT.grdimage(G, J=proj, R=xyrange, C=cpt,V=true)
GMT.coast!(J=proj,R=xyrange,B=frame,W=pen,V=true)

cbxy="11/$figh2/$figh/0.4"
#cbframe="a1000f500/:\"(m)\":"
GMT.colorbar!(B=cbframe, C=cpt, D=cbxy, V=true)

# output
output="./topogmt.png"
tmpps = GMT.fname_out(Dict())[1]
tmpeps= replace(tmpout, r"\.ps$" => ".eps")
run(`ps2eps -f -q $tmpps`)
run(`convert -density 300 $tmpeps $output`)
