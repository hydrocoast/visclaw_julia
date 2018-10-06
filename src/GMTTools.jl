# Plotting with GMT
"""
Convert /tmp/GMTtmp.ps to png file
"""
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

"""
Get the edge of region
"""
function geoR(geo::Claw.geometry)
    xs=geo.x[1]
    xe=geo.x[end]
    ys=geo.y[1]
    ye=geo.y[end]
    xyrange="$xs/$xe/$ys/$ye"
    return xyrange
end
###################################################

"""
Generate grd data with type of Claw.geometry
"""
function geogrd(geo::Claw.geometry; V=false::Bool)

    Δ = (geo.x[end]-geo.x[1])/(geo.ncols-1)
    R = Claw.geoR(geo)
    xvec = repeat(geo.x, inner=(geo.nrows,1))
    yvec = repeat(geo.y, outer=(geo.ncols,1))

    #G = GMT.gmt("surface -R$xyrange -I$Δ", [xvec[:] yvec[:] geo.topo[:]])
    G = GMT.surface([xvec[:] yvec[:] geo.topo[:]], R=R, I=Δ, V=V)

    return G
end
###################################################

"""
Derive height/width ratio
"""
function axratio(geo::Claw.geometry,fwidth::Real)
    xs=geo.x[1]
    xe=geo.x[end]
    ys=geo.y[1]
    ye=geo.y[end]
    fheight = round((ye-ys)/(xe-xs),digits=2)*fwidth
    # return value
    return fheight
end
###################################################

"""
Determine J option
"""
function geoJ(geo::Claw.geometry; proj_base="Xd"::String, fwidth=10::Real)
    # projection and width
    fheight = Claw.axratio(geo, fwidth)
    if length(proj_base)==1
        proj=proj_base*"$fwidth"*"/$fheight"
    elseif length(proj_base)==2
        proj=proj_base[1]*"$fwidth"*proj_base[2]*"/$fheight"*proj_base[2]
    else
        error("Unknown -J option was specified")
    end
    # return value
    return proj
end
###################################################

"""
Generate cpt
"""
function geocpt(palette="earth"::String; crange="-7000/4500"::String, D=true, I=false, V=true, Z=false)

    opt=""
    if D; opt = opt*" -D"; end
    if I; opt = opt*" -I"; end
    if V; opt = opt*" -V"; end
    if Z; opt = opt*" -Z"; end

    cpt = GMT.gmt("makecpt -C$palette -T$crange $opt ")
    return cpt
end
###################################################

"""
Determine colorbar options (vertical alignment)
"""
function cboptD(cbx::Real, cblen::Real)
    cby=cblen/2
    cwid=max(round(0.04*cblen, sigdigits=2),0.25)
    Dcb="$cbx/$cby/$cblen/$cwid"
    # return value
    return Dcb
end
###################################################
