#if !(@isdefined AMR)
    include("src/AMR.jl")
#end

fdir = "../clawpack/geoclaw/examples/storm-surge/ike/_output"
outdir = "./fig/ike"

params = AMR.GeoData(fdir)
gauges = AMR.LoadGauge(fdir, eta0=params.eta0)
