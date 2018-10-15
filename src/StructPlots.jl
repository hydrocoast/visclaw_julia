#########################################
"""
Struct: configuration for Plots
"""
mutable struct PlotsSpec
    dir::String
    cmap::Symbol
    clim::Tuple{Real,Real}
    varname::String
    # Constructor
    Claw.PlotsSpec() = new()
    Claw.PlotsSpec(dir) = new(dir,:coolwarm,(-1.0,1.0),"surface")
    Claw.PlotsSpec(dir,cmap,clim,varname) = new(dir,cmap,clim,varname)
end
#########################################
