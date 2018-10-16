###########################################################
## Function: plot searfloor deformation in 2D, contourf
###########################################################
function PlotsDeform(pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes, outinfo::Claw.OutputSpec)
	# load
    dtopofile, _ = Claw.dtopodata(pltinfo.dir)
    dtopo = Claw.LoadDeform(dtopofile);
    # conditions
    Plots.clibrary(:colorcet)
    # plot
	plt = Plots.contourf(dtopo.x, dtopo.y, dtopo.deform, ratio=:equal, c=pltinfo.cmap, clims=pltinfo.clim)
    plt = Plots.plot!(plt, xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont)
	if !isempty(axinfo.xticks)
		plt = Plots.plot!(plt,xticks=axinfo.xticks)
	end
	if !isempty(axinfo.yticks)
		plt = Plots.plot!(plt,yticks=axinfo.yticks)
	end
    plt = Plots.plot!(plt, tickfont=axinfo.tickfont)

	# filename definition
	output = joinpath(outinfo.figdir,"deformplots.svg")
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
    return plt, dtopo
end
####################################################
function PlotsDeformConf(conf::String="./conf_plots.jl")
	# check
	if !isfile(conf);
		error("Not found: $conf")
    end
	# include
	include(conf)
	pltinfo = Claw.PlotsSpec(maindir,cmap_dtopo,clim_dtopo);
	axinfo = Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
	outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)
	# return value
	return pltinfo, axinfo, outinfo
end
####################################################
