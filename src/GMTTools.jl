# Plotting with GMT
###################################################
"""
Get the edge of region
"""
function geoR(geo::Claw.Topo)
    xs=geo.x[1]
    xe=geo.x[end]
    ys=geo.y[1]
    ye=geo.y[end]
    xyrange="$xs/$xe/$ys/$ye"
    return xyrange
end
###################################################

###################################################
"""
Generate grd data, Claw.geometry
"""
function geogrd(geo::Claw.geometry; kwargs...)

    Δ = (geo.x[end]-geo.x[1])/(geo.ncols-1)
    R = Claw.geoR(geo)
    xvec = repeat(geo.x, inner=(geo.nrows,1))
    yvec = repeat(geo.y, outer=(geo.ncols,1))

    G = GMT.surface([xvec[:] yvec[:] geo.topo[:]]; R=R, I=Δ, kwargs...)

    return G
end
###################################################
"""
Generate grd data, Claw.dtopo
"""
function geogrd(geo::Claw.dtopo; kwargs...)

    Δ = (geo.x[end]-geo.x[1])/(geo.mx-1)
    R = Claw.geoR(geo)
    xvec = repeat(geo.x, inner=(geo.my,1))
    yvec = repeat(geo.y, outer=(geo.mx,1))

    G = GMT.surface([xvec[:] yvec[:] geo.deform[:]]; R=R, I=Δ, kwargs...)

    return G
end
###################################################

###################################################
"""
Derive height/width ratio
"""
function axratio(geo::Claw.Topo, fwidth::Real)
    xs=geo.x[1]
    xe=geo.x[end]
    ys=geo.y[1]
    ye=geo.y[end]
    fheight = round((ye-ys)/(xe-xs), digits=2)*fwidth
    # return value
    return fheight
end
###################################################

###################################################
"""
Determine J option
"""
function geoJ(geo::Claw.Topo; proj_base="X10d"::String)
    # find projection specifier
    J1 = match(r"^([a-zA-Z]+)", proj_base)
    J2 = match(r"([a-zA-Z]+).+?([a-zA-Z]+)", proj_base)
    if J1 === nothing
        error("Invald argument proj_base: $proj_base")
    end

    # assign figure width
    # check whether variable proj_base contains any number
    regex = r"([+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?)"
    chkwidth = match(regex, proj_base)
    if chkwidth === nothing
        fwidth=10
    else
        fwidth = parse(Float64, chkwidth.captures[1])
    end
    # assign figure height
    # check whether variable proj_base contains the height
    regex = r"([+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?).+?([+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?)"
    chkheight = match(regex, proj_base)
    if chkheight === nothing
        fheight = Claw.axratio(geo, fwidth)
    else
        fheight = parse(Float64, chkheight.captures[2])
    end

    # generation of J option
    if occursin("/",proj_base) && chkheight !== nothing
        proj = proj_base
    else
        if J2 === nothing
            proj=J1.captures[1]*"$fwidth"*"/$fheight"
        else
            proj=J1.captures[1]*"$fwidth"*J2.captures[2]*"/$fheight"*J2.captures[2]
        end
    end
    # return value
    return proj
end
###################################################

###################################################
"""
Determine -Dx option in colorbar(psscale), vertical alignment
"""
function cboptDx(;cbx=11::Real, cblen=10::Real, cby=cblen/2,
                 cbwid=max(round(0.04*cblen, sigdigits=2),0.25))
    Dcb="x$cbx/$cby/$cblen/$cbwid"
    # return value
    return Dcb
end
###################################################

###################################################
"""
Determine -Dj option in colorbar(psscale) with +w{length}/{width} and +o{dx}/{dy}
"""
function cboptDj(;loc="BR",cbwid=0.3, cblen=10.0, xoff=-1.5, yoff=0.0)
    Dcb = "j$loc+w$cblen/$cbwid+o$xoff/$yoff"
    return Dcb
end
###################################################

###################################################
"""
Get coverage of tiles
"""
function tileR(tile::Claw.Tiles)
    xs = tile.xlow
    ys = tile.ylow
    xe = round(tile.xlow + tile.mx*tile.dx, digits=4)
    ye = round(tile.ylow + tile.my*tile.dy, digits=4)
    xyrange="$xs/$xe/$ys/$ye"
    # return value
    return xyrange
end
###################################################
#=
function tileR(tiles::AbstractVecor{Claw.Tiles})
    xs = minimum(getfield.(tiles, :xlow))
    ys = minimum(getfield.(tiles, :xlow))
    xe = round(tile.xlow + tile.mx*tile.dx, digits=4)
    ye = round(tile.ylow + tile.my*tile.dy, digits=4)
    xyrange="$xs/$xe/$ys/$ye"
    # return value
    return xyrange
end
###################################################
=#
"""
make a grid file of Claw.Tiles for GMT
"""
function tilegrd(tile::Claw.Tiles; kwargs...)
    # var
    var = Claw.varnameintile(tile)
    # prameters & options
    R = Claw.tileR(tile)
    Δ = tile.dx
    #xvec, yvec, zdata = Claw.tilezcenter(tile, var)
    xvec, yvec, zdata = Claw.tilez(tile, var)
    xmat = repeat(xvec, inner=(length(yvec),1))
    ymat = repeat(yvec, outer=(length(xvec),1))
    # makegrd
    #if !any(.!isnan.(zdata)); return G=nothing; end;
    G = GMT.xyz2grd([xmat[:] ymat[:] zdata[:]], R=R, I=Δ, kwargs...)
    # return value (GMT.GMTgrid)
    return G
end
###################################################

###################################################
"""
convert -B option
"""
function setBscript(B::String)
    if occursin("-B",B); return B; end
    Bopt = replace(B, r"^\s+|\s+$" => "")
    Bopt = replace(Bopt, r"\s+" => " -B")
    Bopt = replace(Bopt, r"^" => "-B")
    return Bopt
end
###################################################
