include("./addpath.jl")
using Claw

# Claw.stormall("ex_conf/conf_storm_ike.jl")
stmall, figinfo, cptinfo, outinfo, coastinfo, timeinfo = Claw.stormall("ex_conf/conf_storm_ike.jl")
