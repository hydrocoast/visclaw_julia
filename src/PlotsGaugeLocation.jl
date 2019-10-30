ms_default=8
an_default = Plots.font(8,:left,:top,0.0,:black)

###########################################
"""
Function: plot gauge location using Plots
"""
function PlotsGaugeLocation!(plt, gauge::Claw.gauge; kwargs...)
    # keyword args
    d = KWARG(kwargs)
    # annotation
    annotation_str=" "*@sprintf("%s",gauge.id)

    # plot
    plt = Plots.scatter!(plt, [gauge.loc[1]], [gauge.loc[2]]; d...,
                         ann=(gauge.loc[1], gauge.loc[2], Plots.text(annotation_str, an_default)),
                         label="")

    # return
    return plt

end
###########################################
PlotsGaugeLocation(gauge::Claw.gauge; kwargs...) =
PlotsGaugeLocation!(Plots.plot(), gauge; kwargs...)
###########################################
function PlotsGaugeLocation!(plt, gauges::Vector{Claw.gauge}; kwargs...)
    # keyword args
    d = KWARG(kwargs)
    # get values in all gauges
    ngauges = length(gauges)
    loc_all = getfield.(gauges, :loc)
    loc = zeros(Float64, ngauges,2)
    for i=1:ngauges; loc[i,:] = loc_all[i]; end

    id_all = getfield.(gauges, :id)
    # annotation
    annotation_str = map(x -> " "*@sprintf("%s",x), id_all)

    annotation_arg = Vector{Tuple}(undef,ngauges)
    for i=1:ngauges
        annotation_arg[i] = (loc_all[i][1], loc_all[i][2], Plots.text(annotation_str[i], an_default))
    end

    # plot
    plt = Plots.scatter!(plt, loc[:,1], loc[:,2]; d...,
                         ann=annotation_arg,
                         label="")

    # return
    return plt
end
###########################################
