### Plotting Tools

#################################
## Function: pseudocolor
#################################
function DrawAMR2D!(plt, amr::T; tilenum=false::Bool, annots=false::Bool,
                    clim=(), cmap=:auto ) where T<:Vector{AMR.patch}
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

		### colorbar ?????
	    #if j==ntile; plt=plot!(plt,colorbar=true); end
    end

    ## xlims, ylims
    xlim, ylim = AMR.Range(amr)
    plt = plot!(plt, xlims=xlim, ylims=ylim)

    ## color range
    if !isempty(clim); plt = plot!(plt, clims=clim); end

        ## Boundaries
        if tilenum
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
function PlotStorm!(plt, storm::T; dc=1, P=true) where T<:Vector{AMR.stormgrid}
    ## the number of tiles
	ntile = length(storm)
    ## preallocate
	xp = zeros(ntile,2);
	yp = zeros(ntile,2);
	## display each tile
    for j = 1:ntile
		## set the boundary
		xp[j,:] = [storm[j].xlow, storm[j].xlow+storm[j].dx*storm[j].mx]
		yp[j,:] = [storm[j].ylow, storm[j].ylow+storm[j].dy*storm[j].my]

		## grid info
		xvec = collect(Float64, xp[j,1]-0.5storm[j].dx:storm[j].dx:xp[j,2]+0.5storm[j].dx+1e-4);
		yvec = collect(Float64, yp[j,1]-0.5storm[j].dy:storm[j].dy:yp[j,2]+0.5storm[j].dy+1e-4);
		## adjust data
        val = zeros(storm[j].my+2, storm[j].mx+2)
		val[2:end-1,2:end-1] = storm[j].slp
		val[2:end-1,1] = val[2:end-1,2]
		val[2:end-1,end] = val[2:end-1,end-1]
		val[1,:] = val[2,:]
		val[end,:] = val[end-1,:]

		## plot
        plt = contour!(plt, xvec, yvec, val, fill=true, c=:amp_r, clims=(960., 1010.), levels=20)
        ## wind field with quiver
        xq = collect(xp[j,1]:storm[j].dx:xp[j,2])
        yq = collect(yp[j,1]:storm[j].dy:yp[j,2])
        plt = quiver!(plt,
                      repeat(xq[1:dc:end], outer=(length(yq[1:dc:end]), 1)),
                      repeat(yq[1:dc:end], inner=(length(xq[1:dc:end]), 1)),
                      quiver=(vec(storm[j].u[1:dc:end,1:dc:end]),
                              vec(storm[j].v[1:dc:end,1:dc:end])),
                      arrow=(:closed, :head, 0.01, 0.01),
                      color=:black,
                      )
    end

    ## get range
    xlim, ylim = AMR.Range(storm)
    plt = plot!(plt, xlims=xlim, ylims=ylim)

    ## Appearances
    plt = plot!(plt, axis_ratio=:equal, xlabel="Longitude", ylabel="Latitude",
                guidefont=font("sans-serif",10), titlefont=font("sans-serif",10))

    # return value(s)
    return plt
end
###########################################

###########################################
## Function: plot time-series of AMR data
###########################################
function PlotTimeSeries(amr::AMR.amr; displaytime=true::Bool, tile=false::Bool, ann=false::Bool,
                        clim=(), cmap=:blues)
    ## plot time-series
    plt = Array{Plots.Plot}(undef,amr.nstep)
    for i = 1:amr.nstep
        #for i = 1:1
        if (displaytime)
            plt[i] = plot(title=@sprintf("%8.1f",amr.timelap[i])*" s", layout=(1,1))
        end
        plt[i] = DrawAMR2D!(plt[i], amr.amr[i], tilenum=tile, annots=ann,
                            clim=clim, cmap=cmap);
    end

    ## return plots
    return plt
end
###########################################

###########################################
## Function: topography and bathymetry
###########################################
function PlotTopo(geo::AMR.geometry)
    plt = contourf(geo.xiter, geo.yiter, geo.topo, ratio=:equal)
    return plt
end
###########################################

###########################################
## Function: topography and bathymetry
###########################################
function CoastalLines(geo::AMR.geometry)
    plt = contour(geo.xiter, geo.yiter, geo.topo, ratio=:equal,
                  levels=1, clims=(0,0), seriescolor=:grays, line=(:solid,1))
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
