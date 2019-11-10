##############################################################################
# Function: draw two-dimensional distribution at a certain step repeatedly
##############################################################################
#function SurfacebyStep(amrs::Claw.AMR, pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes)
#function PlotsCheck(simdir::String, pltinfo::Claw.PlotsSpec, axinfo::Claw.PlotsAxes; vartype="surface"::String)
function PlotsCheck(simdir::String; vartype="surface"::String, kwargs...)

	 ## define the filepath & filename
     if vartype=="surface"
         fnamekw = "fort.q0"
         col=4
		 LoadFunction = Claw.LoadSurface
		 #DrawFunction = Claw.PlotsAMR2D
     elseif vartype=="storm"
         fnamekw = "fort.a0"
         col=5
		 LoadFunction = Claw.LoadStorm
		 #DrawFunction = Claw.PlotsSLP
 	else
 		error("Invalid input argument vartype: $vartype")
     end

     ## make a list
     if !isdir(simdir); error("Directory $simdir doesn't exist"); end
     flist = readdir(simdir)
     idx = occursin.(fnamekw,flist)
     if sum(idx)==0; error("File named $fnamekw was not found"); end
     flist = flist[idx]

 	# load geoclaw.data
 	params = Claw.GeoData(simdir)

    ## the number of files
    nfile = length(flist)


    ### draw figures until nothing or invalid number is input
    ex=0 # initial value
    cnt=0
    while ex==0
        # accept input the step number of interest
        @printf("input the number (1 to %d) = ", nfile)
        i = readline(stdin)
        # check whether the input is integer
        if isempty(i); ex=1; continue; end;
        i=try
             parse(Int64,i)
          catch
             "input $s cannot be parsed to integer"
          end
        if isa(i,String); ex=1; println(i); continue; end;
        # check whether the input is valid number
        if (i>nfile) || (i<1)
            println("Invalid number")
            ex=1
            continue
        end

		amrs = LoadFunction(simdir, i)

        # draw figure
        #plt = DrawFunction(amrs.amr[1], clim=pltinfo.clim, cmap=pltinfo.cmap)
        #plt = Plots.plot!(plt, title=@sprintf("%8.1f",amrs.timelap[1])*" s", layout=(1,1))
        #plt = Plots.plot!(plt, clim=pltinfo.clim, cb=:best)
		plt = Claw.PlotsAMR2D(amrs.amr[1]; kwargs...)
		plt = Plots.plot!(plt, title=@sprintf("%8.1f",amrs.timelap[1])*" s", layout=(1,1))

		# show
		#plt = Plots.plot!(plt, show=true)
		display(plt)
        cnt += 1
    end

    # if no plot is done
    if cnt==0
        plt = nothing
    end
    # return value
    return plt
end
##############################################################################
