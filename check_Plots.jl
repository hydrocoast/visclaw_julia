include("./addpath.jl")
using Claw

# easy checker
### set "./conf_plots.jl"
#Claw.PlotsCheck()

#Claw.PlotsCheck("./ex_conf/conf_plots_chile.jl")
Claw.PlotsCheck("./ex_conf/conf_plots_ike.jl")
