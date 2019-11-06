"""
Function: plot topography and bathymetry in 2D
"""
function PlotsTopo!(plt, geo::Claw.Topo; kwargs...)

    if isa(geo, Claw.geometry)
		z = geo.topo
	elseif isa(geo, Claw.dtopo)
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
PlotsTopo(geo::Claw.Topo; kwargs...) = PlotsTopo!(Plots.plot(), geo; kwargs...)
####################################################
