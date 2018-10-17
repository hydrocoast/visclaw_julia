################################################################################
function PlotsGaugesConf(conf::String="./conf_plots_gauge.jl")
	# check
	if !isfile(conf);
		error("Not found: $conf")
	end
	# include
	include(conf)
	pltinfo = Claw.PlotsSpec(maindir,xlims,ylims);
	axinfo = Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
	outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)
	linespec = Claw.PlotsLineSpec(lw,lc,ls)
	# return value
	return pltinfo, axinfo, outinfo, linespec
end
################################################################################
function PlotsGauges(pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes, outinfo::Claw.OutputSpec;
                     linespec::Claw.PlotsLineSpec=Claw.PlotsLineSpec())
    # Gauges
    # load Sim.
    params = Claw.GeoData(pltinfo.dir)
    gauges = Claw.LoadGauge(pltinfo.dir, eta0=params.eta0)

    # plot Sim.
    plt = Claw.PlotWaveforms(gauges, lc=linespec.color, lw=linespec.width, ls=linespec.style)
	if !isempty(pltinfo.xlims);
        plt = Plots.plot!(plt, xlims=pltinfo.xlims)
    end
    if !isempty(pltinfo.ylims);
        plt = Plots.plot!(plt, ylims=pltinfo.ylims)
    end
    plt = Plots.plot!(plt,xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont, legendfont=axinfo.legfont)
    plt = Plots.plot!(plt,tickfont=axinfo.tickfont, xticks=axinfo.xticks)

	# save the figure
	Claw.PrintPlots(plt,outinfo,"gauges.svg")

	# return value(s)
    return plt, gauges
end
################################################################################
function PlotsGaugeEach(pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes, outinfo::Claw.OutputSpec;
                        linespec::Claw.PlotsLineSpec=Claw.PlotsLineSpec(), gaugeobs="",
						lineobs::Claw.PlotsLineSpec=Claw.PlotsLineSpec(1.0,:black,:dash))
	# Gauges
    # load Sim.
    params = Claw.GeoData(pltinfo.dir)
    gauges = Claw.LoadGauge(pltinfo.dir, eta0=params.eta0)

	# the number of gauges
	ng = length(gauges)
    # preallocate
	plts = Vector{Plots.Plot}(undef,ng)
	# each figure
	for i = 1:ng
        plts[i] = Claw.PlotWaveform(gauges[i], lc=linespec.color, lw=linespec.width, ls=linespec.style)
	    plts[i] = Plots.plot!(plts[i],xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont, legendfont=axinfo.legfont,tickfont=axinfo.tickfont)
	end
	# Claw.PlotsSpec
	if !isempty(pltinfo.xlims);
		plts = map(p -> Plots.plot!(p,xlims=pltinfo.xlims), plts)
	end
	if !isempty(pltinfo.ylims);
		plts = map(p -> Plots.plot!(p,ylims=pltinfo.ylims), plts)
	end
	# Claw.PlotsAxes
	if !isempty(axinfo.xticks);
		plts = map(p -> Plots.plot!(p,xticks=axinfo.xticks), plts)
	end
	if !isempty(axinfo.yticks);
		plts = map(p -> Plots.plot!(p,yticks=axinfo.yticks), plts)
	end

	## observed data
    if !isempty(gaugeobs)
		ngobs = length(gaugeobs)
	    for j = 1:ngobs
			i = findfirst(x -> x==gaugeobs[j].id, getfield.(gauges,:id))
			if isempty(i)
				id = gaugeobs[j].id
				println("Gauge id $id was not found in simulation data.")
				continue
			end
			plts[i] = Claw.PlotWaveform!(plts[i], gaugeobs[j], lc=lineobs.color, lw=lineobs.width, ls=lineobs.style)
	    end
	end

	# check
	if !(outinfo.ext == ".svg" || outinfo.ext == ".png" || outinfo.ext == ".gif")
		println("No file was saved")
	else
		## output
		for i = 1:ng
			svgfile = joinpath(outinfo.figdir,"gauge"*@sprintf("%d",gauges[i].id)*".svg")
			Plots.savefig(plts[i], svgfile)
			if outinfo.ext == ".png"
			    Claw.save2png(plts[i], svgfile, dpi=outinfo.dpi)
		    end
	    end
    end

	# return value(s)
	return plts, gauges
end
