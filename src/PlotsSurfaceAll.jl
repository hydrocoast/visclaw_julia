#=
function PlotsSurfaceAll(amrall::Claw.AMR; bound::Bool=false, gridnumber::Bool=false, minfo::Claw.MarkerSpec=Claw.MarkerSpec())

    # plot
    plts = Claw.PlotsTimeSeries(amrall, clim=pltinfo.clim, cmap=pltinfo.cmap, bound=bound, gridnumber=gridnumber)
	plts = map(p -> Plots.plot!(p,xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont, tickfont=axinfo.tickfont), plts)

    # return value(s)
	return plts
end
=#

###############################################################################
#=
function PlotsSurfaceConf(conf::String="./conf_plots.jl")
    # check
    if !isfile(conf);
        error("Not found: $conf")
    end
    # include
    include(conf)
    pltinfo = Claw.PlotsSpec(cmap_surf,clim_surf,xlims,ylims);
	axinfo = Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
	outinfo = Claw.OutputSpec(figdir,prefix_surf,start_number,ext,dpi,fps,remove_old)
    # return value
    return pltinfo, axinfo, outinfo
end
###############################################################################
function PlotsSurfaceAll(amrall::Claw.AMR, pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes;
	                     bound::Bool=false, gridnumber::Bool=false, minfo::Claw.MarkerSpec=Claw.MarkerSpec())

    # plot
    plts = Claw.PlotsTimeSeries(amrall, clim=pltinfo.clim, cmap=pltinfo.cmap, bound=bound, gridnumber=gridnumber)
	plts = map(p -> Plots.plot!(p,xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont, tickfont=axinfo.tickfont), plts)

	if !isempty(pltinfo.xlims)
		plts = map(p -> Plots.plot!(p,xlims=pltinfo.xlims), plts)
	end
	if !isempty(pltinfo.ylims)
		plts = map(p -> Plots.plot!(p,ylims=pltinfo.ylims), plts)
	end

    # return value(s)
	return plts
end
###############################################################################
=#
