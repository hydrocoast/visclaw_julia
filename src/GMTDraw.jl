function GMTTopo(geo::Claw.geometry, figname="./topogmt.png"::String;
                 fwidth=10::Int64, R=""::String, B="a15f15 neSW"::String,
                 palette="earth"::String, crange="-7000/4500"::String,
                 Bcb="a1000f500/:\"(m)\":"::String, coast=false::Bool)

    # projection and width
    fheight,fheight2 = Claw.axratio(geo, fwidth)
    proj="X$fwidth"*"/$fheight"

    # range
    if isempty(R)
        R=Claw.geoxyrange(geo)
        R="d"*R
    end
    # makecpt
    cpt = GMT.gmt("makecpt -C$palette -T$crange -D -V")
    # makegrd
    G = Claw.geogrd(geo)

    # Topography with grdimage
    GMT.grdimage(G, J=proj, R=R, C=cpt, V=true)
    # draw coastalline if true
    if coast
        pen="0.05"
        GMT.coast!(J=proj, R=R, B=B, W=pen, V=true)
    end

    # colorbar
    cbx=fwidth+1
    cwid=max(round(0.04*fheight, sigdigits=2),0.30)
    Dcb="$cbx/$fheight2/$fheight/$cwid"
    GMT.colorbar!(B=Bcb, C=cpt, D=Dcb, V=true)

    # output
    Claw.saveaspng(figname)

    return nothing
end
