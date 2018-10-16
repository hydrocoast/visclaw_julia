function easycheck(pltspec::Claw.PlotsSpec)
    # load
    amrall = Claw.LoadSurface(pltspec.dir)
    # plt
    plt = Claw.SurfacebyStep(amrall, clim=pltspec.clim, cmap=pltspec.cmap);
    # return value(s)
    return amrall, plt
end

function easycheck(conf::String="conf_plots.jl")
    if !isfile(conf);
        error("File $specfile is not found")
    end
    include(conf)
    pltspec = Claw.PlotsSpec(maindir,cmap,clim)
    amrall, plt = Claw.easycheck(pltspec)
    # return value(s)
    return amrall, plt
end
