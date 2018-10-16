###########################################
## Function: topography and bathymetry
###########################################
function PlotsTopo(pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes, outinfo::Claw.OutputSpec)
	# load
    topofile, _ = Claw.topodata(pltinfo.dir)
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

	# filename definition
	output = joinpath(outinfo.figdir,"topoplots.svg")
	outpng = replace(output, ".svg" => ".png")
	# remove old files if exist
	if outinfo.remove_old
		if isfile(output); rm(output); end
		if isfile(outpng); rm(outpng); end
	end
	# save figure
    Plots.savefig(plt, output)
	println("Printed in $output")
	# convert
	if outinfo.ext == ".png"
		dpi = outinfo.dpi
		outpng = replace(output, ".svg" => ".png")
        #run(`convert -density $dpi $output $outpng`)
        run(`ffmpeg -y -i $output $outpng`)
		#rm(output)
		println("Successfully converted into $outpng")
	end

    # return value(s)
    return plt, geo
end
#=
function PlotTopo(geo::Claw.geometry; clim=(), cmap::Symbol=:delta)
    plt = Plots.contourf(geo.x, geo.y, geo.topo, ratio=:equal, c=cmap, clims=clim)
    return plt
end
=#
###########################################
function PlotsTopoConf(conf::String="./conf_plots.jl")
	# check
	if !isfile(conf);
		error("Not found: $conf")
    end
	# include
	include(conf)
	pltinfo = Claw.PlotsSpec(maindir,cmap_topo,clim_topo);
	axinfo = Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
	outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)
	# return value
	return pltinfo, axinfo, outinfo
end
###########################################
