################################################################################
function PlotsCheck(pltspec::Claw.PlotsSpec)
    # load
    amrall = Claw.LoadSurface(pltspec.dir)
    # plt
    plt = Claw.SurfacebyStep(amrall, clim=pltspec.clim, cmap=pltspec.cmap);
    # return value(s)
    return amrall, plt
end
################################################################################
function PlotsCheck(conf::String="conf_plots.jl")
    if !isfile(conf);
        error("File $specfile is not found")
    end
    include(conf)
    pltspec = Claw.PlotsSpec(maindir,cmap_surf,clim_surf)
    amrall, plt = Claw.PlotsCheck(pltspec)
    # return value(s)
    return amrall, plt
end
################################################################################
