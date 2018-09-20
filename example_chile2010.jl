## Example: Case Chile2010 Tsunami
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018
if !(@isdefined CLAW)
    include("./CLAWPATH.jl")
end
#if !(@isdefined Claw)
    include("src/Claw.jl")
#end

#= *** load, plot and plot if true **** =#
#= booltopo[load,plot,print]  =# booltopo=
[1,1,0] .|> Bool
#= booldtopo[load,plot,print]  =# booldtopo=
[0,0,0] .|> Bool
#= boolgauge[load,plot,print] =# boolgauge=
[0,0,0] .|> Bool
#= booleta[load,plot,print] =# booleta=
[0,0,0] .|> Bool
# animation
anim = 1 |> Bool

## file paths
fdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
outdir = "./fig/chile2010"

using DelimitedFiles: readdlm
using Printf: @printf, @sprintf
using Plots; pyplot()

# Topography
if booltopo[1]
    # load
    topofile, _ = Claw.topodata(fdir)
    geo = Claw.LoadTopo(topofile);
    if booltopo[2]
        # conditions
        Plots.clibrary(:cmocean)
        # plot
        plt = Claw.PlotTopo(geo, clim=(-6000,6000))
        plt = Plots.plot!(plt, xlabel="Longitude", ylabel="Latitude", guidefont=font(12))
        plt = Plots.plot!(plt, tickfont=font(10))
        Plots.plot!(plt,show=true)
        if booltopo[3]
            # save figure(s)
            Plots.savefig(plt, joinpath(outdir,"topo.svg"))
        end
    end
    # coastal lines
    #plt = Claw.CoastalLines(geo)
end

# Deformation
if booldtopo[1]
    # load
    dtopofile, _ = Claw.dtopodata(fdir)
    deform = Claw.LoadDeform(dtopofile);
    if booldtopo[2]
        # conditions
        Plots.clibrary(:colorcet)
        # plot
        plt = Claw.PlotDeform(deform, clim=(-2.0,2.0))
        plt = Plots.plot!(plt, xlabel="Longitude", ylabel="Latitude", guidefont=font(12))
        plt = Plots.plot!(plt, tickfont=font(10))
        Plots.plot!(plt,show=true)
        if booldtopo[3]
            # save figure(s)
            Plots.savefig(plt, joinpath(outdir,"dtopo.svg"))
        end
    end
end

# Gauge
if boolgauge[1]
    # load Sim.
    params = Claw.GeoData(fdir)
    gauges = Claw.LoadGauge(fdir, eta0=params.eta0)

    # load Obs.
    using DelimitedFiles: readdlm
    obsfile=joinpath(fdir,"../32412_notide.txt")
    obs = readdlm(obsfile)
    # Constructor, gauge(label,id,nt,loc,time,eta)
    gaugeobs=Claw.gauge("Gauge 32412 Obs.",32412,size(obs,1),gauges[1].loc,obs[:,1],obs[:,2])

    if boolgauge[2]
        tickv=0:3600:3600*9
        tickl=[@sprintf("%d",i) for i=0:9]
        xl="Time since earthquake (hour)"
        yl="Amplitude (m)"
        # plot Sim.
        plt = Claw.PlotWaveforms(gauges)
        # plot Obs..
        plt = Claw.PlotWaveform!(plt, gaugeobs, lc=:black, lw=.5, ls=:dash)
        plt = plot!(plt,xlims=(-1000.,33000), ylim=(-0.15,0.25))
        plt = plot!(plt,xlabel=xl, ylabel=yl, guidefont=font(12), legendfont=font(10))
        plt = plot!(tickfont=font(10), xticks=(tickv,tickl))
        Plots.plot!(plt,show=true)
        if boolgauge[3]
            # save figure(s)
            Plots.savefig(plt, joinpath(outdir,"gauge32412.svg"))
        end
    end
end

# Free water surface
if booleta[1]
    # load
    amrall = Claw.LoadSurface(fdir)
    if booleta[2]
        # conditions
        cl=(-0.5, 0.5)
        Plots.clibrary(:colorcet)
        # plot
        plt = Claw.PlotTimeSeries(amrall, clim=cl)
        # show gauge locations if any
        if boolgauge[1] && !isempty(gauges)
            plt = map(i->Claw.PlotGaugeLocs!(i,gauges,ms=4,mfc=:black),plt)
        end
        if booleta[3]
            # save figrue(s)
            Claw.PrintPlots(plt, outdir)
        end
    end
end
if anim && Sys.islinux()
    run(`./animation.sh $outdir step eta`)
end

#=
gmttopo = 0
if gmttopo == 1
    import GMT
    outps="topo.ps"

    crange="-7000/4500"
    #cpt = GMT.gmt("makecpt -Crainbow -T$crange -Z -D -N")
    GMT.gmt("makecpt -Cearth -T$crange -Z -D > tmp.cpt")

    xvec = repeat(geo.x, inner=(geo.ncols,1))
    yvec = repeat(geo.y, outer=(geo.nrows,1))
    Δ=(geo.x[end]-geo.x[1])/(geo.ncols-1)
    xyrange="-120/-60/-60/0"
    #G = GMT.surface([xvec[:] yvec[:] geo.topo[:]], R=xyrange, I=Δ)

    open("tmp.txt","w") do f
        tmp = hcat(xvec, yvec, reshape(geo.topo,(geo.nrows*geo.ncols,1)));
        Base.print_array(f,tmp);
    end
    GMT.gmt("xyz2grd tmp.txt -Gtmp.grd -R$xyrange -I$Δ -V")


    afg="-Ba15f15 -Bza2000f2000 -BneSWZ+b"
    xyzrange=xyrange*"/-5000/1500"
    proj="M10"
    zratio="5"
    vw="-150/30"
    #GMT.gmt("grdview tmp.grd -J$proj -JZ$zratio -p$vw -Qi -Ctmp.cpt -K")
    #run(`gmt grdview tmp.grd -Ba15f15 -Bza2000f2000 -BneSWZ+b -J$proj -JZ$zratio -R$xyzrange -p$vw -Qi -Ctmp.cpt -P -K > tmp.ps`)
    run(`gmt grdimage tmp.grd -Ba15f15 -BneSW -J$proj -R$xyrange -Ctmp.cpt -P -K > $outps`)
    run(`gmt pscoast -J -R -Ba15f15 -W -P -V -O -K >> $outps`)

    cbxy="12/6/12/0.4"
    cbafg="-Ba1000f500"
    run(`gmt psscale -Ctmp.cpt -Ba1000f500 -D$cbxy -P -V -O >> $outps`)
end
=#
