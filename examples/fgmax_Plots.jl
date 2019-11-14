using Claw

using Plots
gr() # this code is optimized for the GR backend
clibrary(:colorcet)

# directory
simdir = "your_simulation_path/_output"

# load
fg = Claw.FGmaxData(simdir)
fg = Claw.LoadFGmaxGrid.(fg)
fgmax = Claw.LoadFGmax.(simdir, fg, nval_save=2)
Claw.FGtMinute!.(fgmax)

# plot
plt_h = Claw.PlotsFGmax(fg[1], fgmax[1], :h; linetype=:contourf, color=:heat, clims=(0.0, 2.0), colorbar_title="(m)", title="h")
plt_v = Claw.PlotsFGmax(fg[1], fgmax[1], :v; linetype=:contourf, color=:rainbow, clims=(0.0, 0.2), colorbar_title="(m/s)", title="v")
plt_th = Claw.PlotsFGmax(fg[1], fgmax[1], :th; linetype=:contourf, color=:darktest_r, colorbar_title="(min)", title="th")
plt_tv = Claw.PlotsFGmax(fg[1], fgmax[1], :tv; linetype=:contourf, color=:darktest_r, colorbar_title="(min)", title="tv")

# subplot layout
plts = plot(plt_h, plt_v, plt_th, plt_tv, layout=(2,2), size=(800,600))
