## Example: Case Hurricane Ike
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
[0,0,0] .|> Bool
#= boolgauge[load,plot,print] =# boolgauge=
[1,1,1] .|> Bool
#= booleta[load,plot,print]   =# booleta=
[0,0,0] .|> Bool
#= boolstorm[load,plot,print] =# boolstorm=
[0,0,0] .|> Bool

## ike
fdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
outdir = "./fig/ike"

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
        plt = Claw.PlotTopo(geo, clim=(-4000,4000))
        Plots.plot!(plt,show=true)
        if booltopo[3]
            # save figure(s)
            Plots.savefig(plt, joinpath(outdir,"topo.svg"))
        end
    end
end

# Gauge
if boolgauge[1]
    # load
    params = Claw.GeoData(fdir)
    gauges = Claw.LoadGauge(fdir, eta0=params.eta0)
    if boolgauge[2]
        tickv=-3*24*3600:12*3600:1*24*3600
        tickl=[@sprintf("%d",i) for i=-3*24:12:1*24]
        xl="Hours relative to landfall"
        yl="Surface (m)"
        # plot
        plt = Claw.PlotWaveforms(gauges)
        plt = plot!(plt,xlabel=xl, ylabel=yl, guidefont=font(12),
                    legend=:topleft, legendfont=font(10), grid=true)
        plt = plot!(tickfont=font(10), xticks=(tickv,tickl))
        Plots.plot!(plt,show=true)
        if boolgauge[3]
            # save figure(s)
            Plots.savefig(plt, joinpath(outdir,"allgauges.svg"))
        end
    end
    # plot gauges for each window
    # plts = Claw.PlotWaveform.(gauges)
    # plts = Claw.PrintPlots(plts,outdir,prefix="gauge",startnumber=1)
end

# Free water surface
if booleta[1]
    # load
    amrall = Claw.LoadSurface(fdir)
    if booleta[2]
        # conditions
        cl=(0.0, 2.0)
        Plots.clibrary(:colorcet)
        cpt=:rainbow
        # plot
        plt = Claw.PlotTimeSeries(amrall, bound=true, gridnumber=true, clim=cl, cmap=cpt)
        # show gauge locations if any
        if boolgauge[1] && !isempty(gauges)
            plt = map(i->Claw.PlotGaugeLocs!(i,gauges,ms=4),plt)
        end
        if booleta[3]
            # save figrue(s)
            Claw.PrintPlots(plt, outdir)
        end
    end
end

# Wind and SLP
if boolstorm[1]
    # load
    storm = Claw.LoadStorm(fdir)
    if boolstorm[2]
        # conditions
        Plots.clibrary(:misc)
        # plot
        plt = Claw.PlotTimeSeries(storm, var=:slp, cmap=:heat_r)
        plt = Claw.PlotWindField!(plt, storm, 5, len=0.05)
        if boolstorm[3]
            # save figure(s)
            Claw.PrintPlots(plt, outdir, prefix="slp")
        end
    end
end
