include("./addpath.jl")
using Claw

# topography image with GMT
### set "./conf_topo.jl"
#Claw.bathtopo()

Claw.bathtopo("./ex_conf/conf_topo_chile.jl")
#Claw.bathtopo("./ex_conf/conf_topo_ike.jl")
