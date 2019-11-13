include("./addpath.jl")
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

# load
amrall = Claw.LoadStorm(simdir)
#Claw.RemoveCoarseUV!.(amrall.amr)

# plot
plts = Claw.PlotsTimeSeries(amrall; wind=true, c=:rainbow, clims=(0.0, 40.0),
                            xguide="Longitude", yguide="Latitude",
                            xlims=(-99.0,-85.0), ylims=(22.0,32.0),
                            guidefont=Plots.font("sans-serif",12),
                            tickfont=Plots.font("sans-serif",10),
                            colorbar_title="m/s",
                            )

# save images
Claw.PlotsPrint(plts, "fig/ike_wind.svg")
# gif
Claw.Plotsgif(plts, "fig/ike_wind.gif", fps=4)
