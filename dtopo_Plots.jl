if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

### Topography and bathymetry
pltinfo, axinfo, outinfo = Claw.PlotsDeformConf("./ex_conf/conf_plots.jl")
plt, dtopo = Claw.PlotsDeform(pltinfo,axinfo,outinfo)
