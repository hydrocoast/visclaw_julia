include("./addpath.jl")
using Claw

using Plots
gr()
#plotlyjs()
#pyplot()


# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")

# load water surface
amrall = Claw.LoadSurface(simdir)
# gauge locations (from gauges.data)
gauges = Claw.GaugeData(simdir)

# plot
plts = Claw.PlotsTimeSeries(amrall; c=:coolwarm, clims=(-0.5,0.5),
                            xguide="Longitude", yguide="Latitude",
                            )
plts = map(p -> Claw.PlotsGaugeLocation!(p, gauges; ms=4, color=:black), plts)

# save images
Claw.PlotsPrint(plts, "fig/chile2010_eta.svg")
# gif
Claw.Plotsgif(plts, "fig/chile2010_eta.gif", fps=4)
# -----------------------------


#=
# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")

# load water surface
amrall = Claw.LoadSurface(simdir)
# gauge locations (from gauges.data)
gauges = Claw.GaugeData(simdir)

# plot
plts = Claw.PlotsTimeSeries(amrall; c=:darkrainbow, clims=(-0.5,2.0),
                            xguide="Longitude", yguide="Latitude",
                            xlims=(-99.0,-85.0), ylims=(22.0,32.0),
                            gridnumber=true,
                            )
plts = map(p -> Claw.PlotsGaugeLocation!(p, gauges; color=:white), plts)

# save
Claw.PlotsPrint(plts, "fig/ike_eta.svg")
# gif
Claw.Plotsgif(plts, "fig/ike_eta.gif", fps=4)
# -----------------------------
=#
