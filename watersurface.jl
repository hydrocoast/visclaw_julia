## Example: Case Chile2010 Tsunami
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

#### set ./conf_surf.jl
# Claw.surfaceall()
### or specify conf file
#Claw.surfaceall("ex_conf/conf_surf_chile.jl")
Claw.surfaceall("ex_conf/conf_surf_ike.jl")
