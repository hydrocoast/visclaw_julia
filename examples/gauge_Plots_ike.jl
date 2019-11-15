using Claw
using Printf
### Waveform plots from gauges
using Plots
gr()
#pyplot()

sec1h = 3.6e3
sec1d = 24sec1h

# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
# read
params = Claw.GeoData(simdir)
gauges = Claw.LoadGauge(simdir, eta0=params.eta0)

# plot
plt = Claw.PlotsGaugeWaveform(gauges, lw=1.0)
plt = Plots.plot!(plt;
                  xlims=(-3.0sec1d, 1.0sec1d),
                  ylims=(-0.5,4.0),
                  xlabel="Hours relative to landfall",
                  ylabel="Surface (m)",
                  xticks=(-3.0sec1d:0.5sec1d:1.0sec1d, [@sprintf("%d",i) for i=-3*24:12:1*24]),
                  legendfont=Plots.font("sans-serif",12),
                  guidefont=Plots.font("sans-serif",10),
                  tickfont=Plots.font("sans-serif",10),
                  legend=:topleft,
                  )
# save
Plots.savefig(plt, "ike_waveform_gauge.svg")
# -----------------------------
