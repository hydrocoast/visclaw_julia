######################################
"""
Function: plot values of AMR grids in two-dimension
"""
function PlotsAMR2D!(plt, tiles::AbstractVector{VisClaw.AMRGrid}; wind::Bool=false, kwargs...)

    # check arg
    if isa(tiles[1], VisClaw.SurfaceHeight)
        var = :eta
    elseif isa(tiles[1], VisClaw.Velocity)
        var = :vel
    elseif isa(tiles[1], VisClaw.Storm)
        if wind
            var = :u
        else
            var = :slp
        end
    else
        error("Invalid argument")
    end

    # parse keyword args
    kwdict = KWARG(kwargs)
    # -----------------------------
    # linetype
    seriestype, kwdict = VisClaw.parse_seriestype(kwdict)
    if seriestype == nothing; seriestype=:contourf; end
    # -----------------------------
    # color
    seriescolor, kwdict = VisClaw.parse_seriescolor(kwdict)
    if seriescolor == nothing; seriescolor=:auto; end
    # -----------------------------
    # color axis
    clims, kwdict = VisClaw.parse_clims(kwdict)
    if clims == nothing
        vals = getfield.(tiles, var)
        clims = (
                 minimum(minimum.(v->isnan(v) ?  Inf : v, vals)),
                 maximum(maximum.(v->isnan(v) ? -Inf : v, vals))
                 )
        #clims = (minimum(minimum.(filter.(!isnan, vals))),
        #         maximum(maximum.(filter.(!isnan, vals))))
    end
    # -----------------------------
    # background_color_inside
    bginside, kwdict = VisClaw.parse_bgcolor_inside(kwdict)
    if bginside == nothing; bginside = Plots.RGB(.7,.7,.7); end
    # -----------------------------
    # colorbar_title
    cbtitle, kwdict = VisClaw.parse_colorbar_title(kwdict)
    if cbtitle==nothing; cbtitle=""; end
    # -----------------------------



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
        if !wind
            val[2:end-1,2:end-1] = getfield(tiles[i], var)
        else
            val[2:end-1,2:end-1] = sqrt.(getfield(tiles[i], :u).^2 .+ getfield(tiles[i], :v).^2)
        end
        val[2:end-1,1] = val[2:end-1,2]
        val[2:end-1,end] = val[2:end-1,end-1]
        val[1,:] = val[2,:]
        val[end,:] = val[end-1,:]

        ## plot
        plt = Plots.plot!(plt, xvec, yvec, val, seriestype=seriestype, c=seriescolor, clims=clims, colorbar=false)

    end

    ## xlims, ylims
    xlims, kwdict = VisClaw.parse_xlims(kwdict)
    ylims, kwdict = VisClaw.parse_ylims(kwdict)
    x1, x2, y1, y2 = VisClaw.getlims(tiles)
    xrange = (x1, x2)
    yrange = (y1, y2)
    xlims = xlims==nothing ? xrange : xlims
    ylims = ylims==nothing ? yrange : ylims
    plt = Plots.plot!(plt, xlims=xlims, ylims=ylims)

    if isempty(kwdict); plt = Plots.plot!(plt; kwdict...); end

    ## color range
    #if !isempty(clim); plt = Plots.plot!(plt, clims=clim); end

    ## colorbar
    for i = 2:ntile; plt.series_list[i].plotattributes[:colorbar_entry] = false; end
    plt.series_list[1].plotattributes[:colorbar_entry] = true

    ## Appearances
    plt = Plots.plot!(plt, axis_ratio=:equal, grid=false, bginside=bginside, colorbar=true, colorbar_title=cbtitle)

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
function GridNumber!(plt, tiles; font::Plots.Font=Plots.font(12, :hcenter, :black))
    ## the number of tiles
    ntile = length(tiles)
    for i = 1:ntile
        ## set the boundary
        x = [tiles[i].xlow, tiles[i].xlow+tiles[i].dx*tiles[i].mx]
        y = [tiles[i].ylow, tiles[i].ylow+tiles[i].dy*tiles[i].my]
        ann = @sprintf("%02d", tiles[i].gridnumber)
        ## annotations
        plt = Plots.plot!(plt, annotations=(mean(x),mean(y), Plots.text(ann, font)))
    end
    return plt
end
#######################################

#######################################
"""
Function: draw boundaries
"""
function DrawBound!(plt, tiles; kwargs...)

    # parse keyword args
    kwdict = KWARG(kwargs)

    # linestyle
    linestyle, kwdict = VisClaw.parse_linestyle(kwdict)
    if linestyle == nothing; linestyle=:solid; end
    # linecolor
    linecolor, kwdict = VisClaw.parse_linecolor(kwdict)
    if linecolor == nothing; linecolor=:black; end


    ## the number of tiles
    ntile = length(tiles)
    for i = 1:ntile
        ## set the boundary
        x = [tiles[i].xlow, tiles[i].xlow+tiles[i].dx*tiles[i].mx]
        y = [tiles[i].ylow, tiles[i].ylow+tiles[i].dy*tiles[i].my]
        plt = Plots.plot!(plt,
              [x[1], x[1], x[2], x[2], x[1]],
              [y[1], y[2], y[2], y[1], y[1]],
              label="", linestyle=linestyle, linecolor=linecolor, kwdict...)
    end
    return plt
end
#######################################

#######################################
"""
Function: plot time-series of AMR data
"""
function PlotsAMR(amrs::VisClaw.AMR; kwargs...)
    ## plot time-series
    plt = Array{Plots.Plot}(undef, amrs.nstep)
    for i = 1:amrs.nstep
        plt[i] = VisClaw.PlotsAMR2D(amrs.amr[i]; kwargs...)
    end
    ## return plots
    return plt
end
#############################################
