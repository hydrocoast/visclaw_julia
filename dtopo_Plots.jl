include("./addpath.jl")
using Claw

### Seafloor deformation (for tsunami simulation)

# -----------------------------
# chile 2010
# -----------------------------
# load
simdir = joinpath(Claw.CLAW, "geoclaw/examples/tsunami/chile2010/_output")
dtopofile, ntopo = Claw.dtopodata(simdir)
dtopo = Claw.LoadDeform(dtopofile)
# config
conffile = "./ex_conf/conf_plots_chile.jl"
pltinfo, axinfo, outinfo = Claw.PlotsDeformConf(conffile)
# plot
plt = Claw.PlotsDeform(dtopo, pltinfo, axinfo, outinfo)
# -----------------------------
