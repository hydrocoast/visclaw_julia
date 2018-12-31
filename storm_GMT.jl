include("./addpath.jl")
using Claw

#### set ./conf_surf.jl
# Claw.stormall()
### or specify conf file
# Claw.stormall("ex_conf/conf_storm_ike.jl")
stmall, figinfo, cptinfo, outinfo, coastinfo, timeinfo = Claw.stormall("ex_conf/conf_storm_ike.jl")
