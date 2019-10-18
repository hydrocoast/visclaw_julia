include("./addpath.jl")
using Claw

# -----------------------------
# chile 2010
# -----------------------------
# gaugedata (read only)
pltinfo, axinfo, outinfo, linespec = Claw.PlotsGaugesConf("./ex_conf/conf_gauge_chile.jl")
plttmp, gauges = Claw.PlotsGaugeEach(pltinfo,axinfo,outinfo)

# load configurations
pltinfo, axinfo, outinfo, minfo = Claw.PlotsSurfaceConf("ex_conf/conf_plots_chile.jl")

# load water surface
amrall = Claw.LoadSurface(pltinfo.dir)

# plot
plts = Claw.PlotsSurfaceAll(amrall, pltinfo,axinfo,outinfo, gauges=gauges, minfo=minfo, bound=true, gridnumber=false)
# -----------------------------

#=
# -----------------------------
# ike
# -----------------------------
# gaugedata (read only)
pltinfo, axinfo, outinfo, linespec = Claw.PlotsGaugesConf("./ex_conf/conf_gauge_ike.jl")
_, gauges = Claw.PlotsGaugeEach(pltinfo,axinfo,outinfo)

# load configurations
pltinfo, axinfo, outinfo, minfo = Claw.PlotsSurfaceConf("ex_conf/conf_plots_ike.jl")

# load water surface
amrall = Claw.LoadSurface(pltinfo.dir)

# plot
plts = Claw.PlotsSurfaceAll(amrall, pltinfo,axinfo,outinfo, gauges=gauges, minfo=minfo, bound=true, gridnumber=true)
# -----------------------------
=#
