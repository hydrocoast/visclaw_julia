if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

# topography image with GMT
### set "./conf_topo.jl"
#Claw.bathtopo()

#Claw.bathtopo("./ex_conf/conf_topo_chile.jl")
Claw.bathtopo("./ex_conf/conf_topo_ike.jl")
