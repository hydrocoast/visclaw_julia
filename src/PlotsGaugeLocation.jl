ms_default=8
an_default = Plots.font(8,:left,:top,0.0,:black)

###########################################
"""
Function: plot gauge location using Plots
"""
function PlotsGaugeLoc!(plt, gauge::Claw.gauge; ms=ms_default, mfc=:auto, txtfont=an_default)
    an=" "*@sprintf("%s",gauge.id)
    plt = Plots.scatter!(plt, [gauge.loc[1]], [gauge.loc[2]],
                         ann=(gauge.loc[1],gauge.loc[2],Plots.text(an,txtfont)),
                         ms=ms, color=mfc, label="")
    return plt
end
###########################################
PlotsGaugeLoc(gauge::Claw.gauge; ms=ms_default, mfc=:auto, txtfont=an_default) =
PlotsGaugeLoc!(Plots.plot(), gauge, ms=ms, mfc=mfc, txtfont=txtfont)
###########################################
function PlotsGaugeLocs!(plt, gauges::Vector{Claw.gauge}; ms=ms_default, mfc=:auto, txtfont=an_default)
    # Number of gauges
    ngauge = length(gauges)
    # Check the input arguments
    ms = Claw.chkarglength!(ms,ngauge)
    mfc = Claw.chkarglength!(mfc,ngauge)
    txtfont = Claw.chkarglength!(txtfont,ngauge)
    # plot
    for i = 1:ngauge
        plt = Claw.PlotsGaugeLoc!(plt, gauges[i], ms=ms[i], mfc=mfc[i], txtfont=txtfont[i])
    end
    # return value
    return plt
end
###########################################
function PlotsGaugeLocs(gauges::Vector{Claw.gauge}; ms=ms_default, mfc=:auto, txtfont=an_default)
    plt = Plots.plot()
    plt = PlotsGaugeLocs!(plt, gauges, ms=ms, mfc=mfc, txtfont=txtfont)
    # return value
    return plt
end
###########################################
