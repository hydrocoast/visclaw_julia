################################################################################
function PlotsGauges(pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes, outinfo::Claw.OutputSpec;
                     linespec::Claw.PlotsLineSpec=Claw.PlotsLineSpec())
    # Gauges
    # load Sim.
    params = Claw.GeoData(pltinfo.dir)
    gauges = Claw.LoadGauge(pltinfo.dir, eta0=params.eta0)
    # plot Sim.
    plt = Claw.PlotWaveforms(gauges, lc=linespec.color, lw=linespec.width, ls=linespec.style)
    if !isempty(pltinfo.ylims);
        plt = Plots.plot!(plt,ylims=pltinfo.ylims)
    end
    if !isempty(pltinfo.ylims);
        plt = Plots.plot!(plt,ylims=pltinfo.ylims)
    end
    plt = Plots.plot!(plt,xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont, legendfont=axinfo.legfont)
    plt = Plots.plot!(tickfont=axinfo.tickfont, xticks=axinfo.xticks)

	# filename definition
	output = joinpath(outinfo.figdir,"gauges.svg")
	Claw.savePlots(plt, output, outinfo)

	# return value(s)
    return plt, gauges
end
################################################################################
function PlotsGaugesConf(conf="./conf_plots_gauge.jl")
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
#=
# plot Obs..
plt = Claw.PlotWaveform!(plt, gaugeobs, lc=:black, lw=.5, ls=:dash)
=#
