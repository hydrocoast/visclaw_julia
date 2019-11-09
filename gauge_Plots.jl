include("./addpath.jl")
using Claw
using Printf
### Waveform plots from gauges
using Plots
pyplot()

sec1h = 3.6e3
sec1d = 24sec1h

#struct2dict(x) = Dict(fn=>getfield(x, fn) for fn ∈ fieldnames(typeof(x)))

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


# plot
plt = Claw.PlotsGaugeWaveform(gauges[1], lw=1.0)
plt = Claw.PlotsGaugeWaveform!(plt, gaugeobs[1], lc=:black, lw=1.0, linestyle=:dash)
plt = Plots.plot!(plt; xlims=(-0.5sec1h, 9.5sec1h), ylims=(-0.15, 0.25),
                  xlabel="Time since earthquake (hour)",
                  ylabel="Amplitude (m)",
                  xticks=(0.0:sec1h:9.0sec1h, [@sprintf("%d",i) for i=0:9]),
                  legendfont=Plots.font("sans-serif",12),
                  guidefont=Plots.font("sans-serif",10),
                  tickfont=Plots.font("sans-serif",10),
                  legend=:topright,
                  )

# save
Plots.savefig(plt, "waveform_gauge.svg")
# -----------------------------


# -----------------------------
# ike
# -----------------------------

simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
# read
params = Claw.GeoData(simdir)
gauges = Claw.LoadGauge(simdir, eta0=params.eta0)

# conf simulation result
#conffile ="./ex_conf/conf_plots_gauge_ike.jl"
#pltinfo, axinfo, outinfo = Claw.PlotsGaugeConf(conffile)

# plot
plt = Claw.PlotsGaugeWaveform(gauges, lw=1.0)
plt = Plots.plot!(plt; struct2dict(pltinfo)...)
plt = Plots.plot!(plt;
                  xlims=()
                  xlabel="Hours relative to landfall",
                  ylabel="Surface (m)",
                  xticks=(-3.0sec1d:0.5sec1d:1.0sec1d, [@sprintf("%d",i) for i=-3*24:12:1*24]),
                  legendfont=Plots.font("sans-serif",12),
                  guidefont=Plots.font("sans-serif",10),
                  tickfont=Plots.font("sans-serif",10),
                  legend=:topleft,
                  )
# save
Claw.PrintPlots(plt, outinfo)
# -----------------------------
