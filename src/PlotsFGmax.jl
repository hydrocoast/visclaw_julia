###############################################################################
function PlotsFGmax!(plt, fg::Claw.fgmaxgrid, fgmax::Claw.fgmaxval, var::Symbol; kwargs...)

    # vector
    x = collect(Float64, LinRange(fg.xlims[1], fg.xlims[end], fg.nx))
    y = collect(Float64, LinRange(fg.ylims[1], fg.ylims[end], fg.ny))
    # get var
    val = getfield(fgmax, var)
    #

    #plt = Plots.contourf!(plt, x, y, val; ratio=:equal, xlims=fg.xlims, ylims=fg.ylims, kwargs...)
    plt = Plots.heatmap!(plt, x, y, val; ratio=:equal, xlims=fg.xlims, ylims=fg.ylims, kwargs...)

    # return
    return plt
end
###############################################################################
PlotsFGmax(fg::Claw.fgmaxgrid, fgmax::Claw.fgmaxval, var::Symbol; kwargs...) =
PlotsFGmax!(Plots.plot(), fg, fgmax, var; kwargs...)
###############################################################################

###############################################################################
PlotFGmaxSurf(fg::Claw.fgmaxgrid, fgmax::Claw.fgmaxval; kwargs...) =
PlotFGmax(fg, fgmax, :h; kwargs...)
###############################################################################
