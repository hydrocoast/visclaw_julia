###########################################################
function PlotsDeformConf(conf::String="./conf_plots.jl")
	# check
	if !isfile(conf);
		error("Not found: $conf")
    end
	# include
	include(conf)
	pltinfo = Claw.PlotsSpec(cmap_dtopo,clim_dtopo,xlims,ylims);
	axinfo = Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
	outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)
	# return value
	return pltinfo, axinfo, outinfo
end
###########################################################
###########################################################
## Function: plot searfloor deformation in 2D, contourf
###########################################################
function PlotsDeform(simdir::String, pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes, outinfo::Claw.OutputSpec)
	# load
    dtopofile, _ = Claw.dtopodata(simdir)
    dtopo = Claw.LoadDeform(dtopofile);
    # conditions
    Plots.clibrary(:colorcet)
    # plot
	plt = Plots.contourf(dtopo.x, dtopo.y, dtopo.deform, ratio=:equal, c=pltinfo.cmap, clims=pltinfo.clim)
	# Claw.PlotsSpec
	if !isempty(pltinfo.xlims);
		plt = Plots.plot!(plt,xlims=pltinfo.xlims)
	end
	if !isempty(pltinfo.ylims);
		plt = Plots.plot!(plt,ylims=pltinfo.ylims)
	end
    # Claw.PlotsAxes
    plt = Plots.plot!(plt, xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont)
	if !isempty(axinfo.xticks)
		plt = Plots.plot!(plt,xticks=axinfo.xticks)
	end
	if !isempty(axinfo.yticks)
		plt = Plots.plot!(plt,yticks=axinfo.yticks)
	end
    plt = Plots.plot!(plt, tickfont=axinfo.tickfont)

	# save the figure
    Claw.PrintPlots(plt,outinfo,"deformplots.svg")

    # return value(s)
    return plt, dtopo
end
###########################################################
