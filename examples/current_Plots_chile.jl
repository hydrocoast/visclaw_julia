using VisClaw

using Printf
using Plots
gr()

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
output_prefix = "chile2010_velo"

# load water current
amrall = VisClaw.loadcurrent(simdir)

# plot
plts = VisClaw.plotsamr(amrall; c=:isolum, clims=(0.0,0.1),
                     xguide="Longitude", yguide="Latitude",
                     xlims=(-95,-65), ylims=(-50,-20),
                     guidefont=Plots.font("sans-serif",12),
                     tickfont=Plots.font("sans-serif",10),
                     )

# time in string
time_str = map(x->@sprintf("%03d", x/60.0)*" min", amrall.timelap)
plts = [plot!(plts[i], title=time_str[i]) for i = 1:amrall.nstep]

# save
VisClaw.plotssavefig(plts, output_prefix*".svg")
# gif
VisClaw.plotsgif(plts, output_prefix*".gif", fps=4)
# -----------------------------
