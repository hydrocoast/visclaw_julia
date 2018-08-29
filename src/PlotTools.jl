### Plotting Tools

#################################
## Function: pseudocolor
#################################
function DrawAMR2D!(plt, amr::T; showtile=false::Bool, annots=false::Bool,
                    xlim=(), ylim=(), clim=(), cmap=:blues ) where T<:Vector{AMR.patch}
	### using Plots; gr(); clibrary(:colorcet)
	## the number of tiles
	ntile = length(amr)
	## preallocate
	xp = zeros(ntile,2);
	yp = zeros(ntile,2);
	## display each tile
    for j = 1:ntile
		## set the boundary
		xp[j,:] = [amr[j].xlow, amr[j].xlow+amr[j].dx*amr[j].mx]
		yp[j,:] = [amr[j].ylow, amr[j].ylow+amr[j].dy*amr[j].my]

		## grid info
		xvec = collect(Float64, xp[j,1]-0.5amr[j].dx:amr[j].dx:xp[j,2]+0.5amr[j].dx+1e-4);
		yvec = collect(Float64, yp[j,1]-0.5amr[j].dy:amr[j].dy:yp[j,2]+0.5amr[j].dy+1e-4);
		## adjust data
        val = zeros(amr[j].my+2,amr[j].mx+2)
		val[2:end-1,2:end-1] = amr[j].eta
		val[2:end-1,1] = val[2:end-1,2]
		val[2:end-1,end] = val[2:end-1,end-1]
		val[1,:] = val[2,:]
		val[end,:] = val[end-1,:]

		## plot
	    plt = contour!(plt,xvec,yvec,val, c=(cmap), fill=true, colorbar=false, tickfont=12)
        if !isempty(xlim); plt = plot!(plt, xlims=xlim); end
        if !isempty(ylim); plt = plot!(plt, ylims=ylim); end
        if !isempty(clim); plt = plot!(plt, clims=clim); end

		### colorbar ?????
	    #if j==ntile; plt=plot!(plt,colorbar=true); end
    end

        ## Boundaries
        if showtile
            for j = 1:ntile
			plt = plot!([xp[j,1],xp[j,1],xp[j,2],xp[j,2],xp[j,1]],
			            [yp[j,1],yp[j,2],yp[j,2],yp[j,1],yp[j,1]],
			            c=(:black), linestyle=:solid, label="")
        end
    end

    ## Annotations of the grid number
    if annots
        for j = 1:ntile
            plt = annotate!([(mean(xp[j,:]), mean(yp[j,:]), @sprintf("%02d", amr[j].gridnumber))], fontsize=10)
        end
    end
    ## Appearances
    plt = plot!(plt, axis_ratio=:equal, xlabel="Longitude", ylabel="Latitude",
    guidefont=font("sans-serif",10), titlefont=font("sans-serif",10))
    #plt = plot!(plt, xlims=(xp[1,1], xp[1,2]),ylims=(yp[1,1], yp[1,2]))

    ## return value
    return plt
end
#################################

###########################################
## Function: plot time-series of AMR data
###########################################
function PlotTimeSeries(amr::AMR.amr; displaytime=true::Bool, tile=false::Bool, ann=false::Bool,
                        xlim=(), ylim=(), clim=(), cmap=:blues)
    ## plot time-series
    plt = Array{Plots.Plot}(undef,amr.nstep)
    for i = 1:amr.nstep
        #for i = 1:1
        if (displaytime)
            plt[i] = plot(title=@sprintf("%8.1f",amr.timelap[i])*" s", layout=(1,1))
        end
        plt[i] = DrawAMR2D!(plt[i], amr.amr[i], showtile=tile, annots=ann,
                            xlim=xlim, ylim=ylim, clim=clim, cmap=cmap);
    end

    ## return plots
    return plt
end
###########################################


###########################################
## Function: topography and bathymetry
###########################################
function PrintTopo(geo::AMR.geometry)
    plt = contour(0:geo.ncols-1, 0:geo.nrows-1, geo.topo, fill=true, ratio=:equal, clims=(-6000, 5000), color=:pu_or, levels=11)
    return plt
end
###########################################

###########################################
## Function: Print out
###########################################
function PrintPlots(plt, outdir::String)
    if !isdir(outdir); mkdir(outdir); end
    for i = 1:length(plt)
        Plots.savefig(plt[i], joinpath(outdir, "step"*Printf.@sprintf("%03d",i-1)*".svg"))
    end
end
###########################################
