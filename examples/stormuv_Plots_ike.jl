using Claw

using Plots
gr()
#pyplot()
#plotlyjs()
clibrary(:colorcet)

# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
output_prefix = "fig/ike_wind"
using Dates: Dates
timeorigin = Dates.DateTime(2008, 9, 13, 7)

# load
amrall = Claw.LoadStorm(simdir)

# plot
plts = Claw.PlotsTimeSeries(amrall; c=:rainbow, clims=(0.0, 40.0),
                            xguide="Longitude", yguide="Latitude",
                            xlims=(-99.0,-80.0), ylims=(16.0,32.0),
                            guidefont=Plots.font("sans-serif",12),
                            tickfont=Plots.font("sans-serif",10),
                            colorbar_title="m/s",
                            wind=true,
                            )

# time in string
time_dates = timeorigin .+ Dates.Second.(amrall.timelap)
time_str = Dates.format.(time_dates,"yyyy/mm/dd HH:MM")
plts = [plot!(plts[i], title=time_str[i]) for i = 1:amrall.nstep]

# save
Claw.PlotsPrint(plts, output_prefix*".svg")
# gif
Claw.Plotsgif(plts, output_prefix*".gif", fps=4)
# -----------------------------
