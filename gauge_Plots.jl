if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

### Seafloor deformation (for tsunami simulation)
pltinfo, axinfo, outinfo, linespec = Claw.PlotsGaugesConf("./ex_conf/conf_plots_gauge.jl")
plt, gauges = Claw.PlotsGauges(pltinfo,axinfo,outinfo,linespec=linespec)
