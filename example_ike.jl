## Example: Case Hurricane Ike
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

## ike
fdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
outdir = "./fig/ike"

# Free water surface
    # load
    amrall = Claw.LoadSurface(fdir)
    # conditions
    cl=(0.0, 2.0)
    cpt=:rainbow
    # plot
    plt = Claw.PlotTimeSeries(amrall, bound=true, gridnumber=true, clim=cl, cmap=cpt)
    # show gauge locations if any
    #plt = map(i->Claw.PlotGaugeLocs!(i,gauges,ms=4),plt)
    # save figrue(s)
    Claw.PrintPlots(plt, outdir)

# Wind and SLP
    # load
    storm = Claw.LoadStorm(fdir)
    # conditions
    Plots.clibrary(:misc)
    # plot
    plt = Claw.PlotTimeSeries(storm, cmap=:heat_r)
    plt = Claw.PlotWindField!(plt, storm, 5, len=0.05)
    # save figure(s)
    Claw.PrintPlots(plt, outdir, prefix="slp")
