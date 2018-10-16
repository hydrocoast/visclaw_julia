### Configuration for Plots
### chile2010
dir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output");
clim = (-0.5,0.5);
cmap=:coolwarm
varname = "surface" # "surface" or "storm"

#=
### ike
dir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output");
clim=(0.0,2.0);
cmap=:rainbow
varname = "surface" # "surface" or "storm"
=#
