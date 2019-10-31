################################################################################
function PlotsGaugeConf(conf::String="./conf_plots_gauge.jl")
	# check
	if !isfile(conf);
		error("Not found: $conf")
	end
	# include
	include(conf)
	pltinfo = Claw.PlotsSpec(xlims,ylims);
	axinfo = Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
	outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)

	# return value
	return pltinfo, axinfo, outinfo
end
################################################################################

###########################################
## Function: plot single gauge
###########################################
function PlotsGaugeWaveform!(plt, gauge::Claw.gauge; kwargs...)
    # keyword args
    d = KWARG(kwargs)
    # plot
    plt = Plots.plot!(plt, gauge.time, gauge.eta; label=gauge.label, d...)
    # return
    return plt
end
###########################################
PlotsGaugeWaveform(gauge::Claw.gauge; kwargs...) =
PlotsGaugeWaveform!(Plots.plot(), gauge; kwargs...)
###########################################


###########################################
function PlotsGaugeWaveform!(plt, gauges::Vector{Claw.gauge}; kwargs...)
    # keyword args
    d = KWARG(kwargs)
    # get values in all gauges
    time_all = getfield.(gauges, :time)
    eta_all = getfield.(gauges, :eta)
    label_all = getfield.(gauges, :label)
    # plot
    plt = Plots.plot!(plt, time_all, eta_all; label=label_all, d...)
    # return
    return plt
end
###########################################
PlotsGaugeWaveform(gauges::Vector{Claw.gauge}; kwargs...) =
PlotsGaugeWaveform!(Plots.plot(), gauges; kwargs...)
###########################################
