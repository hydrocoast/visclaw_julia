# Plotting with GMT
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

###################################################
"""
Determine J option
"""
function geoJ(geo::Claw.geometry; proj_base="Xd"::String, fwidth=10::Real, fheight=empty([],Real)::Real)
    # projection and width
    if isempty(fheight)
      fheight = Claw.axratio(geo, fwidth)
    end
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

###################################################
"""
Generate cpt for Claw.geometry
"""
function geocpt(palette="earth"::String; crange="-7000/4500"::String, D=true, I=false, V=true, Z=false)
    # building options
    opt=""
    if D; opt = opt*" -D"; end
    if I; opt = opt*" -I"; end
    if V; opt = opt*" -V"; end
    if Z; opt = opt*" -Z"; end
    # makecpt script
    tmpcpt = "tmp.cpt"
    if Z
        GMT.gmt("makecpt -C$palette $opt > $tmpcpt")
    else
        GMT.gmt("makecpt -C$palette -T$crange $opt > $tmpcpt")
    end
    cpt = GMT.gmt("read -Tc $tmpcpt")
    # remove tmp
    run(`rm -f $tmpcpt`)
    # return cpt
    return cpt
end
###################################################
function geocpt(cptinfo::Claw.ColorSpec)
    Claw.geocpt(cptinfo.cmap,crange=cptinfo.crange,D=cptinfo.D,I=cptinfo.I,V=cptinfo.V,Z=cptinfo.Z)
end

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

###################################################
"""
make a grid file of Claw.Tiles for GMT
"""
function tilegrd(tile::Claw.Tiles; V=true)
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
    G = GMT.xyz2grd([xmat[:] ymat[:] zdata[:]], R=R, I=Δ, V=V)
    # return value (GMT.GMTgrid)
    return G
end
###################################################

###################################################
"""
Generate cpt for Claw.Tiles
"""
tilecpt(palette="polar"::String; crange="-1.0/1.0"::String, D=true, I=false, V=true, Z=false) =
Claw.geocpt(palette,crange=crange, D=D,I=I,V=V,Z=Z)
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
