"""
Function: plot topography and bathymetry in 2D
"""
function PlotsTopo!(plt, geo::Claw.AbstractTopo; kwargs...)

    if isa(geo, Claw.Topo)
		z = geo.elevation
	elseif isa(geo, Claw.DTopo)
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
PlotsTopo(geo::Claw.AbstractTopo; kwargs...) = PlotsTopo!(Plots.plot(), geo; kwargs...)
####################################################
