if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

### Seafloor deformation (for tsunami simulation)
pltinfo, axinfo, outinfo = Claw.PlotsTopoConf("./ex_conf/conf_plots.jl")
plt, deform = Claw.PlotsTopo(pltinfo,axinfo,outinfo)
