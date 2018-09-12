## Example: Case Chile2010 Tsunami
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018
include("./CLAWPATH.jl")
#if !(@isdefined Claw)
    include("src/Claw.jl")
#end

#= *** load, plot and plot if true **** =#
#= booltopo[load,plot,print]  =# booltopo=
[0,0,0] .|> Bool
#= boolgauge[load,plot,print] =# boolgauge=
[1,0,0] .|> Bool
#= booleta[load,plot,print,animation] =# booleta=
[1,1,1,1] .|> Bool

## file paths
fdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
outdir = "./fig/chile2010"
topodir = joinpath(CLAW,"geoclaw/scratch")
toponame = "etopo10min120W60W60S0S.asc"

using Plots
pyplot()

# Topography
if booltopo[1]
    # load
    geo = Claw.LoadTopo(joinpath(topodir,toponame));
    if booltopo[2]
        # conditions
        Plots.clibrary(:cmocean)
        # plot
        plt = Claw.PlotTopo(geo, clim=(-6000,6000))
        Plots.plot!(plt,show=true)
        if booltopo[3]
            # save figure(s)
            Plots.savefig(plt, joinpath(outdir,"topo.svg"))
        end
    end
    # coastal lines
    #plt = Claw.CoastalLines(geo)
end

# Gauge
if boolgauge[1]
    # load
    params = Claw.GeoData(fdir)
    gauges = Claw.LoadGauge(fdir, eta0=params.eta0)
    if boolgauge[2]
        # plot
        plt = Claw.PlotWaveforms(gauges)
        Plots.plot!(plt,show=true)
        if boolgauge[3]
            # save figure(s)
            Plots.savefig(plt, joinpath(outdir,"allgauges.svg"))
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
        cpt=:coolwarm
        # plot
        plt = Claw.PlotTimeSeries(amrall, clim=cl, cmap=cpt)
        # show gauge locations if any
        if boolgauge[1] && !isempty(gauges)
            plt = map(i->Claw.PlotGaugeLocs!(i,gauges,ms=4,mfc=:black),plt)
        end
        if booleta[3]
            # save figrue(s)
            Claw.PrintPlots(plt, outdir)
        end
    end
    if booleta[4] && Sys.islinux()
        run(`./animation.sh  `)
    end
end
