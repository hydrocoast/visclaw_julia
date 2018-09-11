#if !(@isdefined Claw)
    include("src/Claw.jl")
#end

fdir = "../clawpack/geoclaw/examples/storm-surge/ike/_output"
outdir = "./fig/ike"

params = Claw.GeoData(fdir)
gauges = Claw.LoadGauge(fdir, eta0=params.eta0)

plts = Claw.PlotWaveform.(gauges)
plts = Claw.PrintPlots(plts,outdir,prefix="gauge",startnumber=1)

plt = Claw.PlotWaveforms(gauges)
