##############################################################################
# Function: draw two-dimensional distribution at a certain step repeatedly
##############################################################################
#function SurfacebyStep(amrs::Claw.AMR; clim=(), cmap::Symbol=etacmap_default)
function SurfacebyStep(amrs::Claw.AMR, pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes)
    ## check arg
	 if isdefined(amrs.amr[1][1], :eta)
		 DrawFunc=Claw.PlotsAMR2D
	 elseif isdefined(amrs.amr[1][1], :slp)
		 DrawFunc=Claw.PlotsSLP
	 end

    ### display the number of final step
    println("Input anything but integer if you want to exit.")
    @printf("The final step: %d\n",amrs.nstep)

    ### draw figures until nothing or invalid number is input
    ex=0 # initial value
    cnt=0
    while ex==0
        # accept input the step number of interest
        @printf("input the number (1 to %d) = ",amrs.nstep)
        i = readline(stdin)
        # check whether the input is integer
        if isempty(i); ex=1; continue; end;
        i=try
             parse(Int64,i)
          catch
             "Couldn't parse the input to integer"
          end
        if isa(i,String); ex=1; println(i); continue; end;
        # check whether the input is valid number
        if (i>amrs.nstep) || (i<1)
            println("Invalid number")
            ex=1
            continue
        end
        # draw figure
        plt = DrawFunc(amrs.amr[i], clim=pltinfo.clim, cmap=pltinfo.cmap)
        plt = Plots.plot!(plt, title=@sprintf("%8.1f",amrs.timelap[i])*" s", layout=(1,1))
        plt = Plots.plot!(plt,clim=pltinfo.clim, cb=:best)
		# pltinfo
		if !isempty(pltinfo.xlims);
			plt = Plots.plot!(plt,xlims=pltinfo.xlims)
		end
		if !isempty(pltinfo.ylims);
			plt = Plots.plot!(plt,ylims=pltinfo.ylims)
		end
		# axinfo
		plt = Plots.plot!(plt, xlabel=axinfo.xlabel, ylabel=axinfo.ylabel, guidefont=axinfo.labfont,tickfont=axinfo.tickfont)
		if !isempty(axinfo.xticks)
			plt = Plots.plot!(plt,xticks=axinfo.xticks)
		end
		if !isempty(axinfo.yticks)
			plt = Plots.plot!(plt,yticks=axinfo.yticks)
		end

		# show
		plt = Plots.plot!(plt, show=true)
        cnt += 1
    end

    # if no plotting is done
    if cnt==0
        plt = nothing
    end
    # return value
    return plt
end
##############################################################################

################################################################################
function PlotsCheck(pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes)
    # load
    amrall = Claw.LoadSurface(pltinfo.dir)
    # plt
    plt = Claw.SurfacebyStep(amrall, pltinfo, axinfo)

    # return value(s)
    return amrall, plt
end
################################################################################
function PlotsCheck(conf::String="conf_plots.jl")
    if !isfile(conf);
        error("File $specfile is not found")
    end
    include(conf)
    pltinfo = Claw.PlotsSpec(maindir,cmap_surf,clim_surf,xlims,ylims)
	axinfo = Claw.PlotsAxes(xlabel,ylabel,xticks,yticks,labfont,legfont,tickfont)
	outinfo = Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old)
	# plots
    amrall, plt = Claw.PlotsCheck(pltinfo, axinfo)

    # return value(s)
    return amrall, plt
end
################################################################################
