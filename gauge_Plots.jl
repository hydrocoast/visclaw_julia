if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

### Waveform plots from gauges

## chile2010
#pltinfo, axinfo, outinfo, linespec, gaugeobs, lineobs =
#Claw.PlotsGaugesConf("./ex_conf/conf_gauge_chile.jl","./ex_conf/conf_gaugeobs_chile.jl")
#plt, gauges = Claw.PlotsGaugeEach(pltinfo,axinfo,outinfo,linespec=linespec, gaugeobs=gaugeobs, lineobs=lineobs)

## ike case
pltinfo, axinfo, outinfo, linespec =
Claw.PlotsGaugesConf("./ex_conf/conf_gauge_ike.jl")
plt, gauges = Claw.PlotsGauges(pltinfo,axinfo,outinfo,linespec=linespec)
