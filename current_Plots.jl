include("./addpath.jl")
using Claw

using Plots
gr()

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")

# load water current
amrall = Claw.LoadCurrent(simdir)

# plot
plts = Claw.PlotsTimeSeries(amrall; c=:isolum, clims=(0.0,0.1),
                            xguide="Longitude", yguide="Latitude",
                            )

# save images
Claw.PlotsPrint(plts, "fig/chile2010_vel.svg")
# gif
Claw.Plotsgif(plts, "fig/chile2010_vel.gif", fps=4)
# -----------------------------


#=
# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")

# load water current
amrall = Claw.LoadCurrent(simdir)

# plot
plts = Claw.PlotsTimeSeries(amrall; c=:isolum, clims=(0.0,2.0),
                            xguide="Longitude", yguide="Latitude",
                            xlims=(-99.0,-85.0), ylims=(22.0,32.0),
                            gridnumber=true,
                            guidefont=Plots.font("sans-serif",12),
                            tickfont=Plots.font("sans-serif",10),
                            colorbar_title="m/s"
                            )

# save images
Claw.PlotsPrint(plts, "fig/ike_vel.svg")
# gif
Claw.Plotsgif(plts, "fig/ike_vel.gif", fps=4)
# -----------------------------
=#
