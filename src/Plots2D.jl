######################################
"""
Function: plot values of AMR grids in two-dimension
"""
function PlotsAMR2D!(plt, tiles::AbstractVector{Claw.Tiles}; kwargs...)
    # check arg
    if isa(tiles[1], Claw.patch)
        var = :eta
    elseif isa(tiles[1], Claw.uv)
        var = :vel
    elseif isa(tiles[1], Claw.stormgrid)
        var = :slp
    else
        error("Invalid argument")
    end


    # parse keyword args
    kwdict = KWARG(kwargs)
    # linetype
    seriestype, kwdict = Claw.parse_seriestype(kwdict)
    if seriestype == nothing; seriestype=:contourf; end
    # color
    seriescolor, kwdict = Claw.parse_seriescolor(kwdict)
    if seriescolor == nothing; seriescolor=:auto; end
    # color axis
    clims, kwdict = Claw.parse_clims(kwdict)
    if clims == nothing
        vals = getfield.(tiles, var)
        clims = (
                 minimum(minimum.(v->isnan(v) ?  Inf : v, vals)),
                 maximum(maximum.(v->isnan(v) ? -Inf : v, vals))
                 )
        #clims = (minimum(minimum.(filter.(!isnan, vals))),
        #         maximum(maximum.(filter.(!isnan, vals))))
    end
    # background_color_inside
    bginside, kwdict = Claw.parse_bgcolor_inside(kwdict)
    if bginside == nothing; bginside = Plots.RGB(.7,.7,.7); end


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
        plt = Plots.plot!(plt, xvec, yvec, val, seriestype=seriestype, c=seriescolor, clims=clims, colorbar=false)

    end

    ## xlims, ylims
    xlim, ylim = Claw.Range(tiles)
    plt = Plots.plot!(plt, xlims=xlim, ylims=ylim)

    if isempty(kwdict); plt = Plots.plot!(plt; kwdict...); end

    ## color range
    #if !isempty(clim); plt = Plots.plot!(plt, clims=clim); end

    ## colorbar
    for i = 2:ntile; plt.series_list[i].plotattributes[:colorbar_entry] = false; end
    plt.series_list[1].plotattributes[:colorbar_entry] = true

    ## Appearances
    plt = Plots.plot!(plt, axis_ratio=:equal, grid=false, bginside=bginside, colorbar=true)

    ## return value
    return plt
end
######################################
PlotsAMR2D(tiles; kwargs...) =
PlotsAMR2D!(Plots.plot(), tiles; kwargs...)
######################################



#######################################
"""
Function: add the grid numbers
"""
function GridNumber!(plt, tiles; fs=10, fc=:black)
    ## the number of tiles
    ntile = length(tiles)
    for i = 1:ntile
        ## set the boundary
        x = [tiles[i].xlow, tiles[i].xlow+tiles[i].dx*tiles[i].mx]
        y = [tiles[i].ylow, tiles[i].ylow+tiles[i].dy*tiles[i].my]
        ann = @sprintf("%02d", tiles[i].gridnumber)
        ## annotations
        plt = Plots.plot!(plt,annotations=(mean(x),mean(y),Plots.text(ann,fs,fc,:center)))
    end
    return plt
end
#######################################

#######################################
"""
Function: draw boundaries
"""
function DrawBound!(plt, tiles; lc=:black, ls=:solid, lw=1.0)
    ## the number of tiles
    ntile = length(tiles)
    for i = 1:ntile
        ## set the boundary
        x = [tiles[i].xlow, tiles[i].xlow+tiles[i].dx*tiles[i].mx]
        y = [tiles[i].ylow, tiles[i].ylow+tiles[i].dy*tiles[i].my]
        plt = Plots.plot!(plt,
              [x[1], x[1], x[2], x[2], x[1]],
              [y[1], y[2], y[2], y[1], y[1]],
              c=lc, linestyle=ls, linewidth=lw, label="")
    end
    return plt
end
#######################################

#######################################
"""
Function: plot time-series of AMR data
"""
function PlotsTimeSeries(amrs::Claw.AMR; showsec::Bool=true, bound=false::Bool, gridnumber=false::Bool,
                         kwargs...)

    ## plot time-series
    plt = Array{Plots.Plot}(undef,amrs.nstep)
    for i = 1:amrs.nstep
        ## pseudocolor
        #plt[i] = DrawFunc(amrs.amr[i], clim=clim, cmap=cmap)
        plt[i] = Claw.PlotsAMR2D(amrs.amr[i]; kwargs...)

        ## display time in title
        if showsec
            plt[i] = Plots.plot!(plt[i], title=@sprintf("%8.1f",amrs.timelap[i])*" s", layout=(1,1))
        end
        ## draw boundaries
        if bound
            plt[i] = Claw.DrawBound!(plt[i], amrs.amr[i])
        end
        ## annotations of grid number
        if gridnumber
            plt[i] = Claw.GridNumber!(plt[i], amrs.amr[i])
        end

        ## xlims, ylims
        xlim, ylim = Claw.Range(amrs.amr[i])
        plt[i] = Plots.plot!(plt[i], xlims=xlim, ylims=ylim)

    end

    ## return plots
    return plt
end
#############################################
