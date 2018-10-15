function surfaceall(figinfo::Claw.FigureSpec, cptinfo::Claw.ColorSpec ;
                    coastinfo::Claw.CoastSpec=Claw.CoastSpec(), outinfo::Claw.OutputSpec=Claw.OutputSpec())
    # Free water surface
    # load
    amrall = Claw.LoadSurface(figinfo.dir)
    titlestr = Claw.sec2str(amrall.timelap, "hour", fmt="%5.1f")
    # GMT make cpt
    cpt = Claw.tilecpt(cptinfo.cmap, crange=cptinfo.crange, D=cptinfo.D, I=cptinfo.I, V=cptinfo.V, Z=cptinfo.Z)

    # water surface elavation
    Claw.AMRSurf(amrall, cpt, J=figinfo.J, R=figinfo.R, B=figinfo.B, V=figinfo.V);
    # Colorbar
    Claw.AMRColorbar!(amrall, cpt, B=cptinfo.B, D=cptinfo.Dscale, V=cptinfo.V)
    # Coastline
    if coastinfo.hascoast
        Claw.AMRCoast!(amrall, R=figinfo.R, G=coastinfo.G, V=coastinfo.V);
    end
    # Time
    Claw.AMRTitle!(amrall, titlestr, V=figinfo.V)
    # Convert file format
    Claw.ps2eps_series(amrall.nstep)
    Claw.eps2png_series(amrall.nstep, reserve=false)
end
