################################################################################
function surfaceall(figinfo::Claw.FigureSpec, cptinfo::Claw.ColorSpec; timeinfo::Claw.TimeSpec=Claw.TimeSpec(),
                    coastinfo::Claw.CoastSpec=Claw.CoastSpec(), outinfo::Claw.OutputSpec=Claw.OutputSpec())
    # Free water surface
    # load
    amrall = Claw.LoadSurface(figinfo.dir)
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

    # water surface elavation
    Claw.AMRSurf(amrall, cpt, outinfo=outinfo, J=figinfo.J, R=figinfo.R, B=figinfo.B, V=figinfo.V);
    # Colorbar
    Claw.AMRColorbar!(amrall, cpt, outinfo=outinfo, B=cptinfo.B, D=cptinfo.Dscale, V=cptinfo.V)
    # Coastline
    if coastinfo.hascoast
        Claw.AMRCoast!(amrall, outinfo=outinfo, R=figinfo.R, G=coastinfo.G, V=coastinfo.V);
    end
    # Time
    Claw.AMRTitle!(amrall, outinfo=outinfo, titlestr, V=figinfo.V)
    # Convert file format
    ### .ps => .eps => .png => .gif
    if outinfo.ext != ".ps"
        Claw.ps2eps_series(amrall.nstep, outinfo=outinfo)
        if outinfo.ext != ".eps"
            Claw.eps2png_series(amrall.nstep, outinfo=outinfo, reserve=false)
            if outinfo.ext != ".png"
                Claw.makegif(outinfo)
            end
        end
    end
    # return value
    return amrall
end
################################################################################
function surfaceall(conf::String="./conf_surf.jl")
    include(conf)
    figinfo = Claw.FigureSpec(maindir,proj,region,B,V)
    cptinfo = Claw.ColorSpec(cmap,crange,Dscale,Bcb,Dcb,Icb,Vcb,Zcb)
    outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)
    coastinfo = Claw.CoastSpec(hascoast,resolution,coastpen,landfill,seafill,coastV)
    timeinfo = Claw.TimeSpec(origin,format)
    # draw
    amrall = Claw.surfaceall(figinfo,cptinfo,outinfo=outinfo,coastinfo=coastinfo,timeinfo=timeinfo)
    # return value
    return amrall, figinfo, cptinfo, outinfo, coastinfo, timeinfo
end
################################################################################
function surfacegif(conf::String="./conf_surf.jl")
    include(conf)
    outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)
    # make animation
    Claw.makegif(outinfo)
    # return value
    return outinfo
end
