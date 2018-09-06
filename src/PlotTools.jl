### Plotting Tools
slp_default=(960,1015)
arrowhead_default=(0.3,0.3)
arrowlen_default=0.1

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
	    plt = contour!(plt,xvec,yvec,val, c=(cmap), clims=clim, fill=true, colorbar=false, tickfont=10)

		### colorbar ?????
	    #if j==ntile; plt=plot!(plt,colorbar=true); end
    end

    ## xlims, ylims
    xlim, ylim = Claw.Range(tiles)
    plt = plot!(plt, xlims=xlim, ylims=ylim)

    ## color range
    if !isempty(clim); plt = plot!(plt, clims=clim); end

    ## Appearances
    plt = plot!(plt, axis_ratio=:equal, grid=false, xlabel="Longitude", ylabel="Latitude",
    guidefont=font("sans-serif",10), titlefont=font("sans-serif",10), bginside=Plots.RGB(.7,.7,.7))

    ## return value
    return plt
end
######################################
DrawAMR2D(tiles; var=:eta, clim=(), cmap=:auto::Symbol) =
DrawAMR2D!(Plots.plot(), tiles, var=var, clim=clim, cmap=cmap)
######################################
DrawSLP!(plt, tiles; clim=slp_default, cmap=:viridis_r::Symbol) =
DrawAMR2D!(plt, tiles, var=:slp, clim=clim, cmap=cmap)
######################################
DrawSLP(tiles; clim=slp_default, cmap=:viridis_r::Symbol) =
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

###########################################
## Function: Draw wind field with arrows
###########################################
function WindQuiver!(plt,tiles, dc=1::Int;
                     len=arrowlen_default, head=arrowhead_default)
    ## the number of tiles
	ntile = length(tiles)

	## display each tile
    for i = 1:ntile
        ## set the boundary
        x = [tiles[i].xlow, tiles[i].xlow+tiles[i].dx*tiles[i].mx]
        y = [tiles[i].ylow, tiles[i].ylow+tiles[i].dy*tiles[i].my]
        ##
        xq = collect(x[1]:tiles[i].dx:x[2])
        yq = collect(y[1]:tiles[i].dy:y[2])

        plt = quiver!(plt,
                      repeat(xq[1:dc:end], inner=(length(yq[1:dc:end]), 1)),
                      repeat(yq[1:dc:end], outer=(length(xq[1:dc:end]), 1)),
                      quiver=(len*vec(tiles[i].u[1:dc:end,1:dc:end]),
                              len*vec(tiles[i].v[1:dc:end,1:dc:end])),
                      arrow=arrow(:closed, :head, head[1], head[2]), color=:black,
                      )
    end

    ## return
    return plt
end
###########################################
WindQuiver(tiles, dc=1::Int; len=arrowlen_default, head=arrowhead_default) =
WindQuiver!(Plots.plot(), tiles, dc, len=len, head=head)
###########################################

###########################################
## Function: plot time-series of wind field
###########################################
function PlotWindField!(plt, amrs::Claw.amr, dc=1::Int; len=arrowlen_default, head=arrowhead_default)
    for i = 1:amrs.nstep
        plt[i] = Claw.WindQuiver!(plt[i], amrs.amr[i], dc, len=len, head=head)
    end
    ## return plots
    return plt
end
###########################################

###########################################
## Function: plot time-series of AMR data
###########################################
function PlotTimeSeries(amrs::Claw.amr; var=:eta::Symbol,
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
            plt[i] = Claw.DrawAMR2D(amrs.amr[i], clim=clim, cmap=cmap);
        elseif (var==:slp)
            plt[i] = Claw.DrawSLP(amrs.amr[i], clim=clim, cmap=cmap);
        end
        ## display time in title
        if showsec
            plt[i] = plot!(plt[i], title=@sprintf("%8.1f",amrs.timelap[i])*" s", layout=(1,1))
        end
        ## draw boundaries
        if bound
            plt[i] = Claw.DrawBound!(plt[i], amrs.amr[i])
        end
        ## annotations of grid number
        if gridnumber
            plt[i] = Claw.GridNumber!(plt[i], amrs.amr[i])
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
function PlotTopo(geo::Claw.geometry; clim=(), cmap=:delta::Symbol)
    plt = contourf(geo.xiter, geo.yiter, geo.topo, ratio=:equal, c=cmap, clims=clim)
    #!isempty(clim) && (plt = plot!(plt,clims=clim))
    return plt
end
###########################################

###########################################
## Function: topography and bathymetry
###########################################
function CoastalLines!(plt, geo::Claw.geometry)
#function CoastalLines!(plt, geo)
    plt = contour!(plt, geo.xiter, geo.yiter, geo.topo, ratio=:equal,
                   levels=1, clims=(0,0), seriescolor=:grays, line=(:solid,1))
    return plt
end
###########################################
CoastalLines(geo::Claw.geometry) = CoastalLines!(Plots.plot(), geo)
#CoastalLines(geo) = CoastatLines(Plots.plot(), geo)
###########################################
CoastalLineSeq!(plt,geo::Claw.geometry) = map(x->CoastalLines!(x,geo),plt)
#CoastalLineSeq!(plt,geo) = map(x->CoastalLines!(x,geo),plt)
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
