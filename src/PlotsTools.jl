###############################################################################
### Tools using Plots
###############################################################################

#####################################################
"""
Convert .svg files to png file
"""
function svg2png(svgfile::String; dpi::Int64=400)
	outpng = replace(svgfile, ".svg" => ".png")
    #run(`convert -density $dpi $svgfile $outpng`)
    run(`ffmpeg -y -i $svgfile $outpng -loglevel quiet`)
	#rm(svgfile)
	#println("Successfully converted into $outpng")
	# return
    return nothing
end
#####################################################

#####################################################
"""
Print out Vector{Plots.Plot}
"""
function PrintPlots(plts::Vector{T}, outinfo::Claw.OutputSpec) where T<:Plots.Plot
	# check
	if !(outinfo.ext == ".svg" || outinfo.ext == ".png" || outinfo.ext == ".gif")
		println("No file was saved")
		return nothing
	end

	# remove temporary files
    if outinfo.remove_old
        figdir=outinfo.figdir
        prefix=outinfo.prefix
        flist = joinpath.(figdir,filter(x->occursin(prefix,x), readdir(figdir)))
        rm.(filter(x->occursin(".svg",x), flist))
		rm.(filter(x->occursin(".png",x), flist))
		rm.(filter(x->occursin(".gif",x), flist))
    end

	if outinfo.ext != ".svg"
		if isempty(outinfo.dpi); outinfo.dpi==300; end
		plts = map(p -> Plots.plot!(p,dpi=outinfo.dpi), plts)
	end

	# setup
	prefix = joinpath(outinfo.figdir, outinfo.prefix)
	n = outinfo.start_number
	# printout
    for i = 1:length(plts)
		svgname = prefix*@sprintf("%03d",(i-1)+n)*".svg"
		if outinfo.ext == ".svg"
            Plots.savefig(plts[i], svgname)
	    else # outinfo.ext == ".png"
			Plots.savefig(plts[i], replace(svgname, ".svg" => ".png"))
			#Claw.svg2png(svgname, dpi=outinfo.dpi)
		end
    end

	if outinfo.ext == ".gif"
		Claw.makegif(outinfo, orgfmt=".png")
	end

	# return
	return nothing
end
#####################################################
"""
Print out Plots.Plot
"""
function PrintPlots(plt::Plots.Plot, outinfo::Claw.OutputSpec, svgname::String)
	# filename definition
	output = joinpath(outinfo.figdir,svgname)
	# print out
	if !(outinfo.ext == ".svg" || outinfo.ext == ".png" || outinfo.ext == ".gif")
		println("No file was saved")
	else
		Plots.savefig(plt,output)
		if outinfo.ext == ".png"
			Claw.svg2png(output,dpi=outinfo.dpi)
		end
	end
end
#####################################################
"""
Print out Plots.Plot
"""
PrintPlots(plt::Plots.Plot, outinfo::Claw.OutputSpec) =
PrintPlots(plt::Plots.Plot, outinfo::Claw.OutputSpec, outinfo.prefix*".svg")
#####################################################
