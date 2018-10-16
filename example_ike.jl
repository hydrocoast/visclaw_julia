## Example: Case Hurricane Ike
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

## ike
fdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
outdir = "./fig/ike"

using Printf: @printf, @sprintf
using Plots; Plots.pyplot()


# Topography
    # load
    topofile, _ = Claw.topodata(fdir)
    geo = Claw.LoadTopo(topofile);
    Plots.clibrary(:cmocean)
    # plot
    plt = Claw.PlotTopo(geo, clim=(-4000,4000))
    Plots.plot!(plt,show=true)
    # save
    Plots.savefig(plt, joinpath(outdir,"topo.svg"))

# Gauge
    # load
    params = Claw.GeoData(fdir)
    gauges = Claw.LoadGauge(fdir, eta0=params.eta0)
    # plot
    tickv=-3*24*3600:12*3600:1*24*3600
    tickl=[@sprintf("%d",i) for i=-3*24:12:1*24]
    xl="Hours relative to landfall"
    yl="Surface (m)"
    plt = Claw.PlotWaveforms(gauges)
    plt = plot!(plt,xlabel=xl, ylabel=yl, guidefont=font(12),
                legend=:topleft, legendfont=font(10), grid=true)
    plt = plot!(tickfont=font(10), xticks=(tickv,tickl))
    Plots.plot!(plt,show=true)

    # save figure(s)
    Plots.savefig(plt, joinpath(outdir,"allgauges.svg"))
    # plot gauges for each window
    # plts = Claw.PlotWaveform.(gauges)
    # plts = Claw.PrintPlots(plts,outdir,prefix="gauge",startnumber=1)

# Free water surface
    # load
    amrall = Claw.LoadSurface(fdir)
    # conditions
    cl=(0.0, 2.0)
    cpt=:rainbow
    # plot
    plt = Claw.PlotTimeSeries(amrall, bound=true, gridnumber=true, clim=cl, cmap=cpt)
    # show gauge locations if any
    #plt = map(i->Claw.PlotGaugeLocs!(i,gauges,ms=4),plt)
    # save figrue(s)
    Claw.PrintPlots(plt, outdir)

# Wind and SLP
    # load
    storm = Claw.LoadStorm(fdir)
    # conditions
    Plots.clibrary(:misc)
    # plot
    plt = Claw.PlotTimeSeries(storm, cmap=:heat_r)
    plt = Claw.PlotWindField!(plt, storm, 5, len=0.05)
    # save figure(s)
    Claw.PrintPlots(plt, outdir, prefix="slp")
