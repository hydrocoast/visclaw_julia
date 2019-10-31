include("./addpath.jl")
using Claw

### Waveform plots from gauges
using Plots
pyplot()

struct2dict(x) = Dict(fn=>getfield(x, fn) for fn ∈ fieldnames(typeof(x)))

# -----------------------------
# chile 2010
# -----------------------------

## Load observation ##
using DelimitedFiles: readdlm
gaugeobs = Vector{Claw.gauge}(undef,1)
# gauge 32412
obsfile=joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/32412_notide.txt")
obs = readdlm(obsfile)
# Constructor
gaugeobs[1]=Claw.gauge("Gauge 32412 Obs.", 32412, size(obs,1), [], [], obs[:,1], obs[:,2])
##

## Load simulation result ##
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
# read
params = Claw.GeoData(simdir)
gauges = Claw.LoadGauge(simdir, eta0=params.eta0)
##

# conf
conffile = "./ex_conf/conf_plots_gauge_chile.jl"
pltinfo, axinfo, outinfo = Claw.PlotsGaugeConf(conffile)

# plot
plt = Claw.PlotsGaugeWaveform(gauges[1], lw=1.0)
plt = Claw.PlotsGaugeWaveform!(plt, gaugeobs[1], lc=:black, lw=1.0, linestyle=:dash)
plt = Plots.plot!(plt; struct2dict(pltinfo)...)
plt = Plots.plot!(plt; xlabel=axinfo.xlabel, ylabel=axinfo.ylabel,
                       xticks=axinfo.xticks, legend=:topright,
                       guidefont=axinfo.labfont, tickfont=axinfo.tickfont, legendfont=axinfo.legfont)

# save
Claw.PrintPlots(plt, outinfo)
# -----------------------------



# -----------------------------
# ike
# -----------------------------

simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
# read
params = Claw.GeoData(simdir)
gauges = Claw.LoadGauge(simdir, eta0=params.eta0)

# conf simulation result
conffile ="./ex_conf/conf_plots_gauge_ike.jl"
pltinfo, axinfo, outinfo = Claw.PlotsGaugeConf(conffile)

# plot
plt = Claw.PlotsGaugeWaveform(gauges, lw=1.0)
plt = Plots.plot!(plt; struct2dict(pltinfo)...)
plt = Plots.plot!(plt; xlabel=axinfo.xlabel, ylabel=axinfo.ylabel,
                       xticks=axinfo.xticks, legend=:topleft,
                       guidefont=axinfo.labfont, tickfont=axinfo.tickfont, legendfont=axinfo.legfont)
# save
Claw.PrintPlots(plt, outinfo)
# -----------------------------
