################################################################################
function PlotsGaugesConf(conf::String="./conf_plots_gauge.jl")
	# check
	if !isfile(conf);
		error("Not found: $conf")
	end
	# include
	include(conf)
	pltinfo = Claw.PlotsSpec(xlims,ylims);
	axinfo = Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
	outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)

	# return value
	return pltinfo, axinfo, outinfo
end
################################################################################
