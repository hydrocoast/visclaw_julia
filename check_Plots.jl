if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

# easy checker
### set "./conf_plots.jl"
#Claw.PlotsCheck()

#Claw.PlotsCheck("./ex_conf/conf_plots_chile.jl")
Claw.PlotsCheck("./ex_conf/conf_plots_ike.jl")
