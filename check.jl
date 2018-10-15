if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

# easy checker
### set "./conf_plots.jl"
#Claw.easycheck()
Claw.easycheck("./ex_conf/conf_plots.jl")
