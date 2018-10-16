if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

### Topography and bathymetry
#pltinfo, axinfo, outinfo = Claw.PlotsTopoConf("./ex_conf/conf_plots_chile.jl")
pltinfo, axinfo, outinfo = Claw.PlotsTopoConf("./ex_conf/conf_plots_ike.jl")

# Plot
plt, deform = Claw.PlotsTopo(pltinfo,axinfo,outinfo)
