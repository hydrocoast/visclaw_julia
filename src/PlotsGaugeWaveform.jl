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
