include("./addpath.jl")
using Claw

### Seafloor deformation (for tsunami simulation)
simdir = joinpath(Claw.CLAW, "geoclaw/examples/tsunami/chile2010/_output")
conffile = "./ex_conf/conf_plots_chile.jl"
pltinfo, axinfo, outinfo = Claw.PlotsDeformConf(conffile)
plt, dtopo = Claw.PlotsDeform(simdir, pltinfo,axinfo,outinfo)
