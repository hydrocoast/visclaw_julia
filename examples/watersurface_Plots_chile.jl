using VisClaw
using Printf

using Plots
gr()
#plotlyjs()
#pyplot()

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
output_prefix = "chile2010_eta"

# load water surface
amrall = loadsurface(simdir)

# plot
plts = plotsamr(amrall; c=:coolwarm, clims=(-0.5,0.5),
                xguide="Longitude", yguide="Latitude",
                guidefont=Plots.font("sans-serif",12),
                tickfont=Plots.font("sans-serif",10),
                )

# time in string
time_str = map(x->@sprintf("%03d", x/60.0)*" min", amrall.timelap)
plts = map((p,s)->plot!(p, title=s), plts, time_str)

# gauge locations (from gauges.data)
gauges = gaugedata(simdir)
# gauge location
plts = map(p -> plotsgaugelocation!(p, gauges; ms=4, color=:black), plts)

# save
plotssavefig(plts, output_prefix*".svg")
# gif
plotsgif(plts, output_prefix*".gif", fps=4)
# -----------------------------
