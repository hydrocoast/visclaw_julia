function easycheck(pltspec::Claw.PlotsSpec)
    # load
    amrall = Claw.LoadSurface(pltspec.dir,kw=pltspec.varname,eta0=pltspec.eta0)
    # plt
    plt = Claw.SurfacebyStep(amrall, clim=pltspec.clim, cmap=pltspec.cmap);
    # return value(s)
    return amrall, plt
end

function easycheck(specfile::String="conf_plots.jl")
    if !isfile(specfile);
        error("File $specfile is not found")
    end
    include(specfile)
    pltspec = Claw.PlotsSpec(dir,cmap,clim,varname,eta0)
    amrall, plt = Claw.easycheck(pltspec)
    # return value(s)
    return amrall, plt
end
