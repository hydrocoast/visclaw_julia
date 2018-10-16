if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

pltinfo, axinfo, outinfo = Claw.PlotsTopoConf("./ex_conf/conf_plots.jl")
plt, geo = Claw.PlotsTopo(pltinfo,axinfo,outinfo)
