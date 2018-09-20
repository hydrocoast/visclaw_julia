### Plotting Tools
slp_default=(960,1015)
arrowhead_default=(0.3,0.3)
arrowlen_default=0.1
slpcmap_default = :viridis_r
etacmap_default = :coolwarm

######################################
## Function: filled contour
######################################
function DrawAMR2D!(plt, tiles; var=:eta::Symbol, clim=(), cmap=etacmap_default::Symbol)
    if (var!=:eta) && (var!=:slp)
        error("kwargs var is invalid")
    end
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
    plt = plot!(plt, axis_ratio=:equal, grid=false,
               xlabel="Longitude", ylabel="Latitude", guidefont=font("sans-serif",12),
               tickfont=font(10), titlefont=font("sans-serif",10), bginside=Plots.RGB(.7,.7,.7))

    ## return value
    return plt
end
######################################
DrawAMR2D(tiles; var=:eta, clim=(), cmap=etacmap_default::Symbol) =
DrawAMR2D!(Plots.plot(), tiles, var=var, clim=clim, cmap=cmap)
######################################
DrawSLP!(plt, tiles; clim=slp_default, cmap=slpcmap_default::Symbol) =
DrawAMR2D!(plt, tiles, var=:slp, clim=clim, cmap=cmap)
######################################
DrawSLP(tiles; clim=slp_default, cmap=slpcmap_default::Symbol) =
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
WindQuiver(tiles, dc=1::Int64; len=arrowlen_default, head=arrowhead_default) =
WindQuiver!(Plots.plot(), tiles, dc, len=len, head=head)
###########################################

###########################################
## Function: plot time-series of wind field
###########################################
function PlotWindField!(plt, amrs::Claw.amr, dc=1::Int64; len=arrowlen_default, head=arrowhead_default)
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
function PlotTimeSeries(amrs::Claw.amr; var=:eta::Symbol,
                        showsec=true::Bool, bound=false::Bool, gridnumber=false::Bool,
                        clim=(), cmap=etacmap_default)
    ## check argument
    if (var!=:eta) && (var!=:slp)
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
#############################################

##############################################################################
# Function: draw two-dimensional distribution at a certain step repeatedly
##############################################################################
function SurfacebyStep(amrs::Claw.amr; var::Symbol=:eta, clim=(), cmap::Symbol=etacmap_default)
    ## check argument
    if (var!=:eta) && (var!=:slp)
        error("kwargs var is invalid")
    end

    ### display the number of final step
    println("Input anything but integer if you want to exit.")
    @printf("The final step: %d\n",amrs.nstep)

    ### draw figures until nothing or invalid number is input
    ex=0 # initial value
    cnt=0
    while ex==0
        # accept input the step number of interest
        @printf("input the number = ")
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
        if (var==:eta)
            plt = Claw.DrawAMR2D(amrs.amr[i], clim=clim, cmap=cmap)
        elseif (var=:slp)
            plt = Claw.DrawSLP(amrs.amr[i], clim=clim, cmap=cmap)
        end
        plt = plot!(plt, title=@sprintf("%8.1f",amrs.timelap[i])*" s", layout=(1,1))
        plt = Plots.plot!(plt,clim=clim, cb=:best, show=true)
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
SLPbyStep(amrs::Claw.amr; clim=slp_default, cmap::Symbol=slpcmap_default) =
SurfacebyStep(amrs,var=:slp,clim=clim,cmap=cmap)

###########################################
## Function: topography and bathymetry
###########################################
function PlotTopo(geo::Claw.geometry; clim=(), cmap::Symbol=:delta)
    plt = contourf(geo.x, geo.y, geo.topo, ratio=:equal, c=cmap, clims=clim)
    return plt
end
###########################################

###########################################################
## Function: plot searfloor deformation in 2D, contourf
###########################################################
function PlotDeform!(plt,dtopo::Claw.dtopo; clim=(), cmap::Symbol=:coolwarm)
    plt = contourf!(plt,dtopo.x, dtopo.y, dtopo.deform, ratio=:equal, c=cmap, clims=clim)
    return plt
end
###########################################################
PlotDeform(dtopo::Claw.dtopo; clim=(), cmap=:coolwarm::Symbol) =
PlotDeform!(Plots.plot(), dtopo, clim=clim, cmap=cmap)
###########################################################

###########################################
## Function: plot coastal lines
###########################################
function CoastalLines!(plt, geo::Claw.geometry)
    plt = contour!(plt, geo.x, geo.y, geo.topo, ratio=:equal,
                   levels=1, clims=(0,0), seriescolor=:grays, line=(:solid,1))
    return plt
end
###########################################
CoastalLines(geo::Claw.geometry) = CoastalLines!(Plots.plot(), geo)
###########################################
CoastalLineSeq!(plt,geo::Claw.geometry) = map(x->CoastalLines!(x,geo),plt)
###########################################

###########################################
## Function: Print out
###########################################
function PrintPlots(plt, outdir::String; prefix="step"::String, startnumber=0::Int64)
    if !isdir(outdir); mkdir(outdir); end
    for i = 1:length(plt)
        Plots.savefig(plt[i], joinpath(outdir, prefix*@sprintf("%03d",startnumber+i-1)*".svg"))
    end
end
###########################################

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
                         ann=(gauge.loc[1],gauge.loc[2],text(an,txtfont)),
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
###########################################
