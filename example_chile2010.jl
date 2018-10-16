## Example: Case Chile2010 Tsunami
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

# Free water surface
    # load
    amrall = Claw.LoadSurface(fdir)
        # conditions
        cl=(-0.5, 0.5)
        Plots.clibrary(:colorcet)
        # plot
        plt = Claw.PlotTimeSeries(amrall, clim=cl)
        # show gauge locations if any
        #if !isempty(gauges)
        #    plt = map(i->Claw.PlotGaugeLocs!(i,gauges,ms=4,mfc=:black),plt)
        #end
        # save figrue(s)
        Claw.PrintPlots(plt, outdir)

#=
# make animation
if anim && Sys.islinux()
    run(`./animation.sh $outdir step eta`)
end
=#
