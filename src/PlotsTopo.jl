####################################################
function PlotsTopoConf(conf::String="./conf_plots.jl")
	# check
	if !isfile(conf);
		error("Not found: $conf")
    end
	# include
	include(conf)
	pltinfo = Claw.PlotsSpec(cmap_topo,clim_topo,xlims,ylims);
	axinfo = Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
	outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)
	# return value
	return pltinfo, axinfo, outinfo
end
####################################################
## Function: plot topography and bathymetry in 2D
####################################################
function PlotsTopo(simdir::String, pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes, outinfo::Claw.OutputSpec)
	# load
    topofile, _ = Claw.topodata(simdir)
    geo = Claw.LoadTopo(topofile);
    # conditions
    Plots.clibrary(:cmocean)
    # plot
	plt = Plots.contourf(geo.x, geo.y, geo.topo, ratio=:equal, c=pltinfo.cmap, clims=pltinfo.clim)
    plt = Plots.plot!(plt, xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont)
	if !isempty(axinfo.xticks)
		plt = Plots.plot!(plt,xticks=axinfo.xticks)
	end
	if !isempty(axinfo.yticks)
		plt = Plots.plot!(plt,yticks=axinfo.yticks)
	end
    plt = Plots.plot!(plt, tickfont=axinfo.tickfont)

	# save the figure
    Claw.PrintPlots(plt,outinfo,"topoplots.svg")

    # return value(s)
    return plt, geo
end
####################################################
