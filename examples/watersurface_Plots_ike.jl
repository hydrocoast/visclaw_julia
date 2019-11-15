using Claw
using Printf

using Plots
gr()
#plotlyjs()
#pyplot()

# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
output_prefix = "ike_eta"
using Dates: Dates
timeorigin = Dates.DateTime(2008, 9, 13, 7)

# load water surface
amrall = Claw.LoadSurface(simdir)

# plot
plts = Claw.PlotsAMR(amrall; c=:darkrainbow, clims=(-0.5,2.0),
                     xguide="Longitude", yguide="Latitude",
                     xlims=(-99.0,-80.0), ylims=(16.0,32.0),
                     guidefont=Plots.font("sans-serif",12),
                     tickfont=Plots.font("sans-serif",10),
                     )

# time in string
time_dates = timeorigin .+ Dates.Second.(amrall.timelap)
time_str = Dates.format.(time_dates,"yyyy/mm/dd HH:MM")
plts = [plot!(plts[i], title=time_str[i]) for i = 1:amrall.nstep]

# gauge locations (from gauges.data)
gauges = Claw.GaugeData(simdir)
# gauge location
plts = [Claw.PlotsGaugeLocation!(plts[i], gauges; color=:white,
        offset=(0.25,-0.25), font=Plots.font(10, :white)) for i = 1:amrall.nstep]

# tiles
plts = Claw.GridNumber!.(plts, amrall.amr; font=Plots.font(12, :white, :center))
#plts = Claw.DrawBound!.(plts, amrall.amr)

# save
Claw.PlotsPrint(plts, output_prefix*".svg")
# gif
Claw.Plotsgif(plts, output_prefix*".gif", fps=4)
# -----------------------------
