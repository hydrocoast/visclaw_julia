################################################################################
function GMTStormAll(amrall::Claw.AMR, figinfo::Claw.FigureSpec, cptinfo::Claw.ColorSpec;
                     arwinfo::Claw.ArrowSpec=Claw.ArrowSpec(),
                     coastinfo::Claw.CoastSpec=Claw.CoastSpec(),
                     ctrinfo::Claw.ContourSpec=Claw.ContourSpec(),
                     outinfo::Claw.OutputSpec=Claw.OutputSpec(),
                     timeinfo::Claw.TimeSpec=Claw.TimeSpec(),
                    )

    # convert timelaps to string
    titlestr = Claw.sec2str(amrall.timelap, timeinfo.origin, fmt=timeinfo.format)

    # GMT make cpt
    cpt = Claw.tilecpt(cptinfo.cmap, crange=cptinfo.crange, D=cptinfo.D, I=cptinfo.I, V=cptinfo.V, Z=cptinfo.Z)

    # remove temporary files
    if outinfo.remove_old
        figdir=outinfo.figdir
        prefix=outinfo.prefix
        flist = joinpath.(figdir,filter(x->occursin(prefix,x), readdir(figdir)))
        rm.(filter(x->occursin(".png",x), flist))
        rm.(filter(x->occursin(".eps",x), flist))
        rm.(filter(x->occursin(".ps",x), flist))
    end

    for i = 1:amrall.nstep

        # pressure grdimage
        G = Claw.grdpres(amrall.amr[i], R=figinfo.R, T=1.0, V=figinfo.V)
        GMT.grdimage(G, J=figinfo.J, R=figinfo.R, B=figinfo.B, C=cpt, Q=true, V=V)

        # colorbar
        GMT.colorbar!(J=figinfo.J, R="", B=cptinfo.B, C=cpt, D=cptinfo.Dscale, V=cptinfo.V)

        # coastline
        if coastinfo.hascoast
            GMT.coast!(J=figinfo.J, R=figinfo.R, G=coastinfo.G, W=coastinfo.W, V=coastinfo.V)
        end

        # pressure contour
        GMT.grdcontour!(G, J=figinfo.J, R=figinfo.R, B="",
                        A=ctrinfo.A, C=ctrinfo.C,
                        L=ctrinfo.L, W=ctrinfo.W,
                        V=ctrinfo.V)

        # wind field with vector
        arrow = string(arwinfo.A[1])*"/"*string(arwinfo.A[2])*"/"*string(arwinfo.A[3])
        Ssc=arwinfo.S[1]
        Sco=arwinfo.S[2]
        FS=arwinfo.S[3]
        # wind
        tmpfile = Claw.txtwind(amrall.amr[i], skip=arwinfo.skip)
        Claw.psvelo!(tmpfile, J=figinfo.J, R=figinfo.R, B="",
                     A=arrow, S="e$Ssc/$Sco/0", G=arwinfo.G, V=arwinfo.V)
        rm(tmpfile)
        # wind scale
        scalefile="tmpscale.txt"
        txtveloscale(arwinfo.leg[2], arwinfo.leg[3], arwinfo.leg[4], fname=scalefile);
        Claw.psvelo!(scalefile, J=arwinfo.leg[1], R=figinfo.R, B="",
                     A=arrow, S="e$Ssc/$Sco/$FS", G=arwinfo.G, V=arwinfo.V)
        rm(scalefile)

        # title
        str=titlestr[i]
        str="news+t"*str
        str=replace(str, r"\s+" => "_")
        GMT.basemap!(J=figinfo.J,R="",B=str, V=figinfo.V)

        # filename
        filename = prefix*@sprintf("%03d",(i-1)+outinfo.start_number)*".ps"
        # move ps tile
        Claw.moveps(joinpath(outinfo.figdir,filename))
    end

    # Convert file format
    ### .ps => .eps => .png => .gif
    if outinfo.ext != ".ps"
        # ps => eps
        Claw.ps2eps_series(amrall.nstep, outinfo=outinfo)
        if outinfo.ext != ".eps"
            # eps => png
            Claw.eps2png_series(amrall.nstep, outinfo=outinfo, reserve=false)
            if outinfo.ext == ".gif"
                # png => gif
                Claw.makegif(outinfo)
            end
        end
    end

    # return value
    return amrall
end
################################################################################
function GMTStormConf(conf::String="./conf_gmtstorm.jl")
    include(conf)
    figinfo = Claw.FigureSpec(proj,region,B,V)
    cptinfo = Claw.ColorSpec(cmap,crange,Dscale,Bcb,Dcb,Icb,Vcb,Zcb)
    outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)
    coastinfo = Claw.CoastSpec(hascoast,resolution,coastpen,landfill,seafill,coastV)
    ctrinfo = Claw.ContourSpec(Acon,Ccon,Lcon,Wcon,Vcon)
    arwinfo = Claw.ArrowSpec(Avel,Svel,Gvel,skipvel,legvel,Vvel)
    timeinfo = Claw.TimeSpec(origin,format)

    # return value
    return figinfo, cptinfo, outinfo, coastinfo, ctrinfo, arwinfo, timeinfo
end
################################################################################
