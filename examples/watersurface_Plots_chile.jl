using Claw
using Printf

using Plots
gr()
#plotlyjs()
#pyplot()

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
output_prefix = "fig/chile2010_eta"

# load water surface
amrall = Claw.LoadSurface(simdir)

# plot
plts = Claw.PlotsAMR(amrall; c=:coolwarm, clims=(-0.5,0.5),
                     xguide="Longitude", yguide="Latitude",
                     guidefont=Plots.font("sans-serif",12),
                     tickfont=Plots.font("sans-serif",10),
                            )

# time in string
time_str = map(x->@sprintf("%03d", x/60.0)*" min", amrall.timelap)
plts = [plot!(plts[i], title=time_str[i]) for i = 1:amrall.nstep]

# gauge locations (from gauges.data)
gauges = Claw.GaugeData(simdir)
# gauge location
plts = map(p -> Claw.PlotsGaugeLocation!(p, gauges; ms=4, color=:black), plts)

# save
Claw.PlotsPrint(plts, output_prefix*".svg")
# gif
Claw.Plotsgif(plts, output_prefix*".gif", fps=4)
# -----------------------------
