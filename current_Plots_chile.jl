using Claw

using Plots
gr()

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
output_prefix = "fig/chile2010_eta"

# load water current
amrall = Claw.LoadCurrent(simdir)

# plot
plts = Claw.PlotsTimeSeries(amrall; c=:isolum, clims=(0.0,0.1),
                            xguide="Longitude", yguide="Latitude",
                            guidefont=Plots.font("sans-serif",12),
                            tickfont=Plots.font("sans-serif",10),
                            )

# time in string
time_str = map(x->@sprintf("%03d", x/60.0)*" min", amrall.timelap)
plts = [plot!(plts[i], title=time_str[i]) for i = 1:amrall.nstep]

# save
Claw.PlotsPrint(plts, output_prefix*".svg")
# gif
Claw.Plotsgif(plts, output_prefix*".gif", fps=4)
# -----------------------------
