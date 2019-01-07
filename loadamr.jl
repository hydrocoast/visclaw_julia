include("./addpath.jl")
using Claw

# load only (no figure is generated)

# Ike
expath = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output")
stms = Claw.LoadStorm(expath)
surfs = Claw.LoadSurface(expath)

#=
# chile2010
expath = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
surfs = Claw.LoadSurface(expath)
=#
