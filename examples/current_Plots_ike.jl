using VisClaw

using Printf
using Plots
gr()

# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
output_prefix = "ike_velo"
using Dates: Dates
timeorigin = Dates.DateTime(2008, 9, 13, 7)

# load water current
amrall = VisClaw.loadcurrent(simdir)

# plot
plts = VisClaw.plotsamr(amrall; c=:isolum, clims=(0.0,2.0),
                     xguide="Longitude", yguide="Latitude",
                     xlims=(-99.0,-80.0), ylims=(16.0,32.0),
                     guidefont=Plots.font("sans-serif",12),
                     tickfont=Plots.font("sans-serif",10),
                     colorbar_title="m/s"
                     )

# time in string
time_dates = timeorigin .+ Dates.Second.(amrall.timelap)
time_str = Dates.format.(time_dates,"yyyy/mm/dd HH:MM")
plts = [plot!(plts[i], title=time_str[i]) for i = 1:amrall.nstep]

# gauge locations (from gauges.data)
gauges = VisClaw.gaugedata(simdir)
# gauge location
plts = [VisClaw.plotsgaugelocation!(plts[i], gauges; color=:orange,
        offset=(0.25,-0.25), font=Plots.font(10, :white)) for i = 1:amrall.nstep]

# tiles
plts = VisClaw.gridnumber!.(plts, amrall.amr; font=Plots.font(12, :black, :center))
plts = VisClaw.tilebound!.(plts, amrall.amr)

# save
VisClaw.plotssavefig(plts, output_prefix*".svg")
# gif
VisClaw.plotsgif(plts, output_prefix*".gif", fps=4)
# -----------------------------
