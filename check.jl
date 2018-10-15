# easy checker
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw
# check
Claw.easycheck()
