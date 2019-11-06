###############################################################################
function PlotsFGmax!(plt, fg::Claw.fgmaxgrid, fgmax::Claw.fgmaxval, var::Symbol; kwargs...)

    # vector
    x = collect(Float64, LinRange(fg.xlims[1], fg.xlims[end], fg.nx))
    y = collect(Float64, LinRange(fg.ylims[1], fg.ylims[end], fg.ny))

    # ocean grids
    ocean = fgmax.bath.<=0.0

    # get var
    val = getfield(fgmax, var)
    # check
    if isempty(val); error("Empty: $var"); end
    # correct
    if var==:h
        val[ocean] = val[ocean] + fgmax.bath[ocean]
    elseif var==:hmin
        val[ocean] = -val[ocean] + fgmax.bath[ocean]
    end

    val[.!ocean] .= NaN

    # plot
    plt = Plots.plot!(plt, x, y, val; ratio=:equal, xlims=fg.xlims, ylims=fg.ylims, kwargs...)

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
