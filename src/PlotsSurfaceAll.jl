###############################################################################
function PlotsSurfaceConf(conf::String="./conf_plots.jl")
    # check
    if !isfile(conf);
        error("Not found: $conf")
    end
    # include
    include(conf)
    pltinfo = Claw.PlotsSpec(maindir,cmap_surf,clim_surf,xlims,ylims);
	axinfo = Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
	outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)
    markerinfo = Claw.MarkerSpec(msize,mcolor,mfont)
    # return value
    return pltinfo, axinfo, outinfo, markerinfo
end
###############################################################################
function PlotsSurfaceAll(pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes, outinfo::Claw.OutputSpec;
	                     bound::Bool=true, gridnumber::Bool=false, gauges="", minfo::Claw.MarkerSpec=Claw.MarkerSpec())
    # Free water surface
    # load
    amrall = Claw.LoadSurface(pltinfo.dir)
    # plot
    plts = Claw.PlotTimeSeries(amrall, clim=pltinfo.clim, cmap=pltinfo.cmap, bound=bound, gridnumber=gridnumber)
	plts = map(p -> Plots.plot!(p,xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont,tickfont=axinfo.tickfont), plts)

	if !isempty(pltinfo.xlims);
		plts = map(p -> Plots.plot!(p,xlims=pltinfo.xlims), plts)
	end
	if !isempty(pltinfo.ylims);
		plts = map(p -> Plots.plot!(p,ylims=pltinfo.ylims), plts)
	end

    # show gauge locations if any
	if !isempty(gauges) && isa(gauges,Vector{Claw.gauge})
        plts = map(p -> Claw.PlotGaugeLocs!(p,gauges,ms=minfo.msize, mfc=minfo.mcolor, txtfont=minfo.mfont), plts)
	end

	# remove temporary files
    if outinfo.remove_old
        figdir=outinfo.figdir
        prefix=outinfo.prefix
        flist = joinpath.(figdir,filter(x->occursin(prefix,x), readdir(figdir)))
        rm.(filter(x->occursin(".svg",x), flist))
		rm.(filter(x->occursin(".png",x), flist))
		rm.(filter(x->occursin(".gif",x), flist))
    end

	# save figures
	Claw.PrintPlots(plts,outinfo)
	if outinfo.ext == ".gif"
		Claw.makegif(outinfo, orgfmt=".svg")
	end

    # return value(s)
	return plts, amrall
end
###############################################################################
