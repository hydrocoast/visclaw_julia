################################################################################
function PlotsGaugesConf(conf::String="./conf_plots_gauge.jl", confobs::String="")
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
	# include obs data of nto empty
	if isempty(confobs)
		# return value
		return pltinfo, axinfo, outinfo, linespec
	else
		# check
		if !isfile(confobs);
			error("Not found: $confobs")
		end
        include(confobs)
		lineobs = Claw.PlotsLineSpec(lwobs,lcobs,lsobs)

		# return value
		return pltinfo, axinfo, outinfo, linespec, gaugeobs, lineobs
    end
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

	# filename definition
	output = joinpath(outinfo.figdir,"gauges.svg")
	Claw.savePlots(plt, output, outinfo)

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
	    plts[i] = Plots.plot!(plts[i],xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont, legendfont=axinfo.legfont)
	    plts[i] = Plots.plot!(plts[i],tickfont=axinfo.tickfont, xticks=axinfo.xticks)
	end
	if !isempty(pltinfo.xlims);
		plts = map(p -> Plots.plot!(p,xlims=pltinfo.xlims), plts)
	end
	if !isempty(pltinfo.ylims);
		plts = map(p -> Plots.plot!(p,ylims=pltinfo.ylims), plts)
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

	## output
	for i = 1:ng
		output = joinpath(outinfo.figdir,"gauge"*@sprintf("%d",gauges[i].id)*".svg")
		Claw.savePlots(plts[i], output, outinfo)
    end

	# return value(s)
	return plts, gauges
end
