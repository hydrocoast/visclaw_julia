include("./addpath.jl")
using Claw

# topography image with GMT

# -----------------------------
# chile 2010
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
conffile = "./ex_conf/conf_gmttopo_chile.jl"
Claw.bathtopo(simdir, conffile)
# -----------------------------

# -----------------------------
# ike
# -----------------------------
simdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
conffile = "./ex_conf/conf_gmttopo_ike.jl"
Claw.bathtopo(simdir, conffile)
# -----------------------------
