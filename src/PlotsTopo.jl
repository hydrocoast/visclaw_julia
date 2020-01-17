"""
Function: plot topography and bathymetry in 2D
"""
function PlotsTopo!(plt, geo::VisClaw.AbstractTopo; kwargs...)

    if isa(geo, VisClaw.Topo)
		z = geo.elevation
	elseif isa(geo, VisClaw.DTopo)
		z = geo.deform
	end

	# plot
	plt = Plots.plot!(plt, geo.x, geo.y, z;
	                  xlims=extrema(geo.x), ylims=extrema(geo.y),
	                  axis_ratio=:equal, kwargs...)

	# return
	return plt
end
####################################################
"""
Function: plot topography and bathymetry in 2D
"""
PlotsTopo(geo::VisClaw.AbstractTopo; kwargs...) = PlotsTopo!(Plots.plot(), geo; kwargs...)
####################################################

####################################################
"""
Function: plot a range of topo/bath
"""
function PlotsTopoRange!(plt, geo::VisClaw.AbstractTopo; kwargs...)

	xp = [geo.x[1],  geo.x[1]  , geo.x[end], geo.x[end], geo.x[1]]
	yp = [geo.y[1],  geo.y[end], geo.y[end], geo.y[1]  , geo.y[1]]

	# plot
	plt = Plots.plot!(plt, xp, yp; kwargs...)

	return plt
end
####################################################
PlotsTopoRange(geo::VisClaw.AbstractTopo; kwargs...) = PlotsTopoRange!(Plots.plot(), geo; kwargs...)
####################################################
