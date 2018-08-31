### Plotting Tools

######################################
## Function: filled contour
######################################
function DrawAMR2D!(plt, tiles; var=:eta::Symbol, clim=(), cmap=:auto::Symbol)
    if (var!=:eta) & (var!=:slp)
        error("kwargs var is invalid")
    end
	## the number of tiles
	ntile = length(tiles)

	## display each tile
    for i = 1:ntile
        ## set the boundary
        x = [tiles[i].xlow, tiles[i].xlow+tiles[i].dx*tiles[i].mx]
        y = [tiles[i].ylow, tiles[i].ylow+tiles[i].dy*tiles[i].my]

		## grid info
		xvec = collect(Float64, x[1]-0.5tiles[i].dx:tiles[i].dx:x[2]+0.5tiles[i].dx+1e-4);
		yvec = collect(Float64, y[1]-0.5tiles[i].dy:tiles[i].dy:y[2]+0.5tiles[i].dy+1e-4);
		## adjust data
        val = zeros(tiles[i].my+2,tiles[i].mx+2)
        val[2:end-1,2:end-1] = getfield(tiles[i], var)
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
    xlim, ylim = AMR.Range(tiles)
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
DrawAMR2D(tiles; var=:eta, clim=(), cmap=:auto::Symbol) =
DrawAMR2D!(Plots.plot(), tiles, var=var, clim=clim, cmap=cmap)
######################################
DrawSLP!(plt, tiles; clim=(960,1010), cmap=:viridis_r::Symbol) =
DrawAMR2D!(plt, tiles, var=:slp, clim=clim, cmap=cmap)
######################################
DrawSLP(tiles; clim=(960,1010), cmap=:viridis_r::Symbol) =
DrawSLP!(Plots.plot(), tiles, clim=clim, cmap=cmap)
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

#=
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
=#
###########################################
## Function: plot time-series of AMR data
###########################################
function PlotTimeSeries(amrs::AMR.amr; var=:eta::Symbol,
                        showsec=true::Bool, bound=false::Bool, gridnumber=false::Bool,
                        clim=(), cmap=:auto)
    ## check argument
    if (var!=:eta) & (var!=:slp)
        error("kwargs var is invalid")
    end
    ## plot time-series
    plt = Array{Plots.Plot}(undef,amrs.nstep)
    for i = 1:amrs.nstep
        ## pseudocolor
        if (var==:eta)
            plt[i] = AMR.DrawAMR2D(amrs.amr[i], clim=clim, cmap=cmap);
        elseif (var==:slp)
            plt[i] = AMR.DrawSLP(amrs.amr[i], clim=clim, cmap=cmap);
        end
        ## display time in title
        if showsec
            plt[i] = plot!(plt[i], title=@sprintf("%8.1f",amrs.timelap[i])*" s", layout=(1,1))
        end
        ## draw boundaries
        if bound
            plt[i] = AMR.DrawBound!(plt[i], amrs.amr[i])
        end
        ## annotations of grid number
        if gridnumber
            plt[i] = AMR.GridNumber!(plt[i], amrs.amr[i])
        end
    end

    ## return plots
    return plt
end
###########################################

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
function PrintPlots(plt, outdir::String; prefix="step"::String)
    if !isdir(outdir); mkdir(outdir); end
    for i = 1:length(plt)
        Plots.savefig(plt[i], joinpath(outdir, prefix*@sprintf("%03d",i-1)*".svg"))
    end
end
###########################################
