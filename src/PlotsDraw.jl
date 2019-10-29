slp_default=(960,1015)
arrowhead_default=(0.3,0.3)
arrowlen_default=0.1
slpcmap_default = :viridis_r
etacmap_default = :coolwarm
######################################
## Function: filled contour
######################################
function PlotsAMR2D!(plt, tiles::AbstractVector{Claw.Tiles}; clim=(), cmap=etacmap_default::Symbol)
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

    # colormap
    if cmap==:rainbow; Plots.clibrary(:colorcet); end

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
	    plt = Plots.contour!(plt,xvec,yvec,val, c=(cmap), clims=clim, fill=true, colorbar=false, tickfont=10)

    end

    ## xlims, ylims
    xlim, ylim = Claw.Range(tiles)
    plt = Plots.plot!(plt, xlims=xlim, ylims=ylim)

    ## color range
    if !isempty(clim); plt = Plots.plot!(plt, clims=clim); end

	## colorbar
	for i = 2:ntile; plt.series_list[i].plotattributes[:colorbar_entry] = false; end
    plt.series_list[1].plotattributes[:colorbar_entry] = true

    ## Appearances
    plt = Plots.plot!(plt, axis_ratio=:equal, grid=false, bginside=Plots.RGB(.7,.7,.7), colorbar=true)

    ## return value
    return plt
end
######################################
PlotsAMR2D(tiles; clim=(), cmap=etacmap_default::Symbol) =
PlotsAMR2D!(Plots.plot(), tiles, clim=clim, cmap=cmap)
######################################
PlotsSLP!(plt, tiles; clim=slp_default, cmap=slpcmap_default::Symbol) =
PlotsAMR2D!(plt, tiles, clim=clim, cmap=cmap)
######################################
PlotsSLP(tiles; clim=slp_default, cmap=slpcmap_default::Symbol) =
PlotsSLP!(Plots.plot(), tiles, clim=clim, cmap=cmap)
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
        plt = Plots.plot!(plt,annotations=(mean(x),mean(y),Plots.text(ann,fs,fc,:center)))
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
        plt = Plots.plot!(plt,
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
function WindQuiver!(plt,tiles, dc=1::Int64;
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

        plt = Plots.quiver!(plt,
              repeat(xq[1:dc:end], inner=(length(yq[1:dc:end]), 1)),
              repeat(yq[1:dc:end], outer=(length(xq[1:dc:end]), 1)),
              quiver=(len*vec(tiles[i].u[1:dc:end,1:dc:end]),
                      len*vec(tiles[i].v[1:dc:end,1:dc:end])),
                      arrow=Plots.arrow(:closed, :head, head[1], head[2]), color=:black,
                      )
    end

    ## return
    return plt
end
###########################################
WindQuiver(tiles, dc=1::Int64; len=arrowlen_default, head=arrowhead_default) =
WindQuiver!(Plots.plot(), tiles, dc, len=len, head=head)
###########################################

###########################################
## Function: plot time-series of wind field
###########################################
function PlotWindField!(plt, amrs::Claw.AMR, dc=1::Int64; len=arrowlen_default, head=arrowhead_default)
    for i = 1:amrs.nstep
        plt[i] = Claw.WindQuiver!(plt[i], amrs.amr[i], dc, len=len, head=head)
    end
    ## return plots
    return plt
end
###########################################

#############################################
## Function: plot time-series of AMR data
#############################################
function PlotTimeSeries(amrs::Claw.AMR; showsec=true::Bool, bound=false::Bool, gridnumber=false::Bool,
                        clim=(), cmap=etacmap_default)
    #=
    ## check arg
	if isa(tiles[1], Claw.patch)
		vartype=""
	elseif isa(tiles[1], Claw.uv)
		DrawFunc=Claw.PlotsAMR2D
	elseif isa(tiles[1], Claw.stormgrid)
		DrawFunc=Claw.PlotsSLP
	end
	=#
	#=
	if isdefined(amrs.amr[1][1], :eta)
		DrawFunc=Claw.PlotsAMR2D
	elseif isdefined(amrs.amr[1][1], :slp)
		DrawFunc=Claw.PlotsSLP
	end
	=#

    ## plot time-series
    plt = Array{Plots.Plot}(undef,amrs.nstep)
    for i = 1:amrs.nstep
        ## pseudocolor
        #plt[i] = DrawFunc(amrs.amr[i], clim=clim, cmap=cmap)
		plt[i] = Claw.PlotsAMR2D(amrs.amr[i], clim=clim, cmap=cmap)

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
    end

    ## return plots
    return plt
end
#############################################

###########################################
## Function: plot single gauge
###########################################
function PlotWaveform!(plt, gauge::Claw.gauge; lc=:auto, lw=1., ls=:solid)
    plt = Plots.plot!(plt, gauge.time, gauge.eta, lc=lc, lw=lw, linestyle=ls, label=gauge.label);
    return plt
end
###########################################
PlotWaveform(gauge::Claw.gauge; lc=:auto, lw=1., ls=:solid) =
PlotWaveform!(Plots.plot(),gauge, lc=lc, lw=lw, ls=ls)
###########################################

###########################################
## Function: plot gauge
###########################################
function PlotWaveforms!(plt, gauges::Vector{Claw.gauge}; lc=:auto, lw=1., ls=:solid)
    # Number of gauges
    ngauge = length(gauges)
    # Check the input arguments
    lc = Claw.chkarglength!(lc,ngauge)
    lw = Claw.chkarglength!(lw,ngauge)
    ls = Claw.chkarglength!(ls,ngauge)
    # plot
    for i = 1:ngauge
        plt = Claw.PlotWaveform!(plt, gauges[i], lc=lc[i], lw=lw[i], ls=ls[i])
    end
    # return value
    return plt
end
###########################################
function PlotWaveforms(gauges::Vector{Claw.gauge}; lc=:auto, lw=1., ls=:solid)
    plt = Plots.plot()
    plt = Claw.PlotWaveforms!(plt,gauges,lc=lc,lw=lw,ls=ls)
    # return value
    return plt
end
###########################################

ms_default=8
an_default = Plots.font(8,:left,:top,0.0,:black)
###########################################
## Function: plot gauge location
###########################################
function PlotGaugeLoc!(plt, gauge::Claw.gauge; ms=ms_default, mfc=:auto, txtfont=an_default)
    an=" "*@sprintf("%s",gauge.id)
    plt = Plots.scatter!(plt, [gauge.loc[1]], [gauge.loc[2]],
                         ann=(gauge.loc[1],gauge.loc[2],Plots.text(an,txtfont)),
                         ms=ms, color=mfc, label="")
    return plt
end
###########################################
PlotGaugeLoc(gauge::Claw.gauge; ms=ms_default, mfc=:auto, txtfont=an_default) =
PlotGaugeLoc!(Plots.plot(), gauge, ms=ms, mfc=mfc, txtfont=txtfont)
###########################################
function PlotGaugeLocs!(plt, gauges::Vector{Claw.gauge}; ms=ms_default, mfc=:auto, txtfont=an_default)
    # Number of gauges
    ngauge = length(gauges)
    # Check the input arguments
    ms = Claw.chkarglength!(ms,ngauge)
    mfc = Claw.chkarglength!(mfc,ngauge)
    txtfont = Claw.chkarglength!(txtfont,ngauge)
    # plot
    for i = 1:ngauge
        plt = Claw.PlotGaugeLoc!(plt, gauges[i], ms=ms[i], mfc=mfc[i], txtfont=txtfont[i])
    end
    # return value
    return plt
end
###########################################
function PlotGaugeLocs(gauges::Vector{Claw.gauge}; ms=ms_default, mfc=:auto, txtfont=an_default)
    plt = Plots.plot()
    plt = PlotGaugeLocs!(plt, gauges, ms=ms, mfc=mfc, txtfont=txtfont)
    # return value
    return plt
end
###########################################
