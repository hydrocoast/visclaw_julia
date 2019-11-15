using Claw

using Plots
gr()
#pyplot()
#plotlyjs()

# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
output_prefix = "ike_pres"
using Dates: Dates
timeorigin = Dates.DateTime(2008, 9, 13, 7)

# load
amrall = Claw.LoadStorm(simdir)

# plot
plts = Claw.PlotsAMR(amrall; c=:heat_r, clims=(960.0, 1010.0),
                     xguide="Longitude", yguide="Latitude",
                     xlims=(-99.0,-85.0), ylims=(22.0,32.0),
                     guidefont=Plots.font("sans-serif",12),
                     tickfont=Plots.font("sans-serif",10),
                     colorbar_title="hPa",
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
