include("./addpath.jl")
using Claw

### Seafloor deformation (for tsunami simulation)
pltinfo, axinfo, outinfo = Claw.PlotsDeformConf("./ex_conf/conf_plots_chile.jl")
plt, dtopo = Claw.PlotsDeform(pltinfo,axinfo,outinfo)
