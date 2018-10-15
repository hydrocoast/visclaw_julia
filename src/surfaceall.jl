################################################################################
function surfaceall(figinfo::Claw.FigureSpec, cptinfo::Claw.ColorSpec;
                    coastinfo::Claw.CoastSpec=Claw.CoastSpec(), outinfo::Claw.OutputSpec=Claw.OutputSpec())
    # Free water surface
    # load
    amrall = Claw.LoadSurface(figinfo.dir)
    titlestr = Claw.sec2str(amrall.timelap, "hour", fmt="%5.1f")
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
    if outinfo.ext == ".eps" || outinfo.ext == ".png"
        Claw.ps2eps_series(amrall.nstep, outinfo=outinfo)
    end
    if outinfo.ext == ".png"
        Claw.eps2png_series(amrall.nstep, outinfo=outinfo, reserve=false)
    end
    # return value

end
################################################################################
function surfaceall(conf::String="./conf_surf.jl")
    include(conf)
    figinfo = Claw.FigureSpec(maindir,proj,region,B,V)
    cptinfo = Claw.ColorSpec(cmap,crange,Dscale,Bcb,Dcb,Icb,Vcb,Zcb)
    outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,remove_old)
    coastinfo = Claw.CoastSpec(hascoast,resolution,coastpen,landfill,seafill,coastV)
    # draw
    Claw.surfaceall(figinfo,cptinfo,coastinfo=coastinfo,outinfo=outinfo)
    # return value
    return figinfo, cptinfo, outinfo, coastinfo
end
################################################################################
