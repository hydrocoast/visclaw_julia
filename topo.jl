# topography image with GMT
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

### set "./conf_topo.jl"
Claw.GMTTopo()
