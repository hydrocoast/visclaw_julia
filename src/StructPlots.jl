#########################################
"""
Struct: configuration for Plots
"""
mutable struct PlotsSpec
    dir::String
    cmap::Symbol
    clim::Tuple{Real,Real}
    varname::String
    eta0::Float64
    # Constructor
    Claw.PlotsSpec() = new()
    Claw.PlotsSpec(dir) = new(dir,:coolwarm,(-1.0,1.0),"surface",0.0)
    Claw.PlotsSpec(dir,) = new(dir,:coolwarm,(-1.0,1.0),"surface",0.0)
    Claw.PlotsSpec(dir,cmap,clim,varname,eta0) = new(dir,cmap,clim,varname,eta0)
end
#########################################
