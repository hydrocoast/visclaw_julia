if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

#### set ./conf_plots.jl
#pltinfo, axinfo, outinfo = Claw.PlotsSurfaceConf()

### or specify conf file

## chile
# gaugedata (read only)
pltinfo, axinfo, outinfo, linespec = Claw.PlotsGaugesConf("./ex_conf/conf_gauge_chile.jl")
outinfo.ext = "";
plttmp, gauges = Claw.PlotsGaugeEach(pltinfo,axinfo,outinfo)
# configuration
pltinfo, axinfo, outinfo, minfo = Claw.PlotsSurfaceConf("ex_conf/conf_plots_chile.jl")
# plot
plts, amrall = Claw.PlotsSurfaceAll(pltinfo,axinfo,outinfo, gauges=gauges, minfo=minfo, bound=true, gridnumber=false)

## ike
pltinfo, axinfo, outinfo, linespec = Claw.PlotsGaugesConf("./ex_conf/conf_gauge_ike.jl")
outinfo.ext = "";
_, gauges = Claw.PlotsGaugeEach(pltinfo,axinfo,outinfo)
pltinfo, axinfo, outinfo, minfo = Claw.PlotsSurfaceConf("ex_conf/conf_plots_ike.jl")
plts, amrall = Claw.PlotsSurfaceAll(pltinfo,axinfo,outinfo, gauges=gauges, minfo=minfo, bound=true, gridnumber=true)
