include("./addpath.jl")
using Claw

#### set ./conf_surf.jl
# Claw.surfaceall()
### or specify conf file
Claw.surfaceall("ex_conf/conf_surf_chile.jl")
#Claw.surfaceall("ex_conf/conf_surf_ike.jl")
