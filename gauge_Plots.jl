if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

### Waveform plots from gauges
## chile2010
# obs data
include("./ex_conf/conf_gaugeobs_chile.jl")
lineobs = Claw.PlotsLineSpec(lwobs,lcobs,lsobs)
# load
pltinfo, axinfo, outinfo, linespec = Claw.PlotsGaugesConf("./ex_conf/conf_gauge_chile.jl")
plt, gauges = Claw.PlotsGaugeEach(pltinfo,axinfo,outinfo,linespec=linespec, gaugeobs=gaugeobs, lineobs=lineobs)


## ike case
pltinfo, axinfo, outinfo, linespec = Claw.PlotsGaugesConf("./ex_conf/conf_gauge_ike.jl")
plt, gauges = Claw.PlotsGauges(pltinfo,axinfo,outinfo,linespec=linespec)
