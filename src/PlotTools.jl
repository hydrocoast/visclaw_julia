### Plotting Tools

######################################
## Function: filled contour
######################################
function DrawAMR2D!(plt, amr::T; clim=(), cmap=:auto) where T<:Vector{AMR.patch}
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

    ## Appearances
    plt = plot!(plt, axis_ratio=:equal, xlabel="Longitude", ylabel="Latitude",
    guidefont=font("sans-serif",10), titlefont=font("sans-serif",10))

    ## return value
    return plt
end
######################################
DrawAMR2D(amr; clim=(), cmap=:auto) = DrawAMR2D!(Plots.plot(), amr, clim=clim, cmap=cmap)
######################################

#######################################
## Function: Add the grid numbers
#######################################
function GridNumber!(plt, tiles; fs=10, fc=:black)
    ## the number of tiles
	ntile = length(tiles)
    for i = 1:ntile
        ## set the boundary
        x = [tiles[i].xlow, tiles[i].xlow+tiles[i].dx*tiles[i].mx]
        y = [tiles[i].ylow, tiles[i].ylow+tiles[i].dy*tiles[i].my]
        ann = @sprintf("%02d", tiles[i].gridnumber)
        ## annotations
        plt = plot!(plt,annotations=(mean(x),mean(y),text(ann,fs,fc,:center)))
    end
    return plt
end
#######################################

#######################################
## Function: Draw the boundaries
#######################################
function DrawBound!(plt, tiles; lc=:black, ls=:solid, lw=1.0)
    ## the number of tiles
	ntile = length(tiles)
    for i = 1:ntile
        ## set the boundary
        x = [tiles[i].xlow, tiles[i].xlow+tiles[i].dx*tiles[i].mx]
        y = [tiles[i].ylow, tiles[i].ylow+tiles[i].dy*tiles[i].my]
        plt = plot!(plt,
                    [x[1], x[1], x[2], x[2], x[1]],
                    [y[1], y[2], y[2], y[1], y[1]],
                    c=lc, linestyle=ls, linewidth=lw, label="")
    end
    return plt
end
#######################################

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
function PlotTimeSeries(amr::AMR.amr; showsec=true::Bool, bound=false::Bool, gridnumber=false::Bool,
                        clim=(), cmap=:auto)
    ## plot time-series
    plt = Array{Plots.Plot}(undef,amr.nstep)
    for i = 1:amr.nstep
        ## pseudocolor
        plt[i] = AMR.DrawAMR2D(amr.amr[i], clim=clim, cmap=cmap);
        ## display time in title
        if showsec
            plt[i] = plot!(plt[i], title=@sprintf("%8.1f",amr.timelap[i])*" s", layout=(1,1))
        end
        ## draw boundaries
        if bound
            plt[i] = AMR.DrawBound!(plt[i], amr.amr[i])
        end
        ## annotations of grid number
        if gridnumber
            plt[i] = AMR.GridNumber!(plt[i], amr.amr[i])
        end
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
        Plots.savefig(plt[i], joinpath(outdir, "step"*@sprintf("%03d",i-1)*".svg"))
    end
end
###########################################
