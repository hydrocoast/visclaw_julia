# Plotting with GMT

###################################################
## Function: convert /tmp/GMTtmp.ps to png file
###################################################
function saveaspng(outpng::String; dpi=300::Int64)
    if !occursin("/",outpng)
        outpng="./"*outpng
    end
    tmpps = GMT.fname_out(Dict())[1]
    tmpeps= replace(tmpps, r"\.ps$" => ".eps")
    run(`ps2eps -f -q $tmpps`)
    run(`convert -density $dpi $tmpeps $outpng`)

    return nothing
end
###################################################

###################################################
## Function: for -R option
###################################################
function geoxyrange(geo::Claw.geometry)
    xs=geo.x[1]
    xe=geo.x[end]
    ys=geo.y[1]
    ye=geo.y[end]
    xyrange="$xs/$xe/$ys/$ye"
    return xyrange
end
###################################################

###################################################
## Function: height/width ratio
###################################################
function axratio(geo::Claw.geometry,figw)
    xs=geo.x[1]
    xe=geo.x[end]
    ys=geo.y[1]
    ye=geo.y[end]
    figh = round((ye-ys)/(xe-xs),digits=2)*figw
    figh2=figh/2.

    return figh, figh2
end
###################################################

###################################################
## Function: generate grd data with type of Claw.geometry
###################################################
function geogrd(geo::Claw.geometry)

    Δ=(geo.x[end]-geo.x[1])/(geo.ncols-1)
    xyrange=Claw.geoxyrange(geo)
    xvec = repeat(geo.x, inner=(geo.nrows,1))
    yvec = repeat(geo.y, outer=(geo.ncols,1))

    #G = GMT.gmt("surface -R$xyrange -I$Δ", [xvec[:] yvec[:] geo.topo[:]])
    G = GMT.surface([xvec[:] yvec[:] geo.topo[:]], R=xyrange, I=Δ)

    return G
end
###################################################
