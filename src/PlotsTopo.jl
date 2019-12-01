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
PlotsTopo!(plt, geo::Vector, num::Int64=1; kwargs...) = PlotsTopo!(plt, geo[num]; kwargs...)
####################################################
PlotsTopo(geo::Vector, num::Int64=1; kwargs...) = PlotsTopo!(Plots.plot(), geo[num]; kwargs...)
####################################################
