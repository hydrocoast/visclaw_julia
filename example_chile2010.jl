## Example: Case Chile2010 Tsunami
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

## file paths
fdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
outdir = "./fig/chile2010"

using DelimitedFiles: readdlm
using Printf: @printf, @sprintf
using Plots; Plots.pyplot()

# Gauge
    # load Sim.
    params = Claw.GeoData(fdir)
    gauges = Claw.LoadGauge(fdir, eta0=params.eta0)

    # load Obs.
    using DelimitedFiles: readdlm
    obsfile=joinpath(fdir,"../32412_notide.txt")
    obs = readdlm(obsfile)
    # Constructor, gauge(label,id,nt,loc,time,eta)
    gaugeobs=Claw.gauge("Gauge 32412 Obs.",32412,size(obs,1),gauges[1].loc,obs[:,1],obs[:,2])

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
    # save figure(s)
    Plots.savefig(plt, joinpath(outdir,"gauge32412.svg"))

# Free water surface
    # load
    amrall = Claw.LoadSurface(fdir)
        # conditions
        cl=(-0.5, 0.5)
        Plots.clibrary(:colorcet)
        # plot
        plt = Claw.PlotTimeSeries(amrall, clim=cl)
        # show gauge locations if any
        #if !isempty(gauges)
        #    plt = map(i->Claw.PlotGaugeLocs!(i,gauges,ms=4,mfc=:black),plt)
        #end
        # save figrue(s)
        Claw.PrintPlots(plt, outdir)

#=
# make animation
if anim && Sys.islinux()
    run(`./animation.sh $outdir step eta`)
end
=#
