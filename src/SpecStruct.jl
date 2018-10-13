#########################################
"""
Struct: Topography output configuration
"""
mutable struct TopoSpec
    dir::String
    outdir::String
    FigW::Real
    FigH::Real
    B::String
    hascoast::Bool
    V::Bool
    # Constructor
    Claw.TopoSpec() = new()
    Claw.TopoSpec(dir,outdir,FigH,B,hascoast) = new(dir,outdir,FigH,empty([],Real),hascoast,B,false)
    Claw.TopoSpec(dir,outdir,FigH,FigH,B,hascoast) = new(dir,outdir,FigH,FigH,hascoast,B,false)
    Claw.TopoSpec(dir,outdir,FigH,B,hascoast,V) = new(dir,outdir,FigH,empty([],Real),hascoast,B,V)
    Claw.TopoSpec(dir,outdir,FigH,FigH,B,hascoast,V) = new(dir,outdir,FigH,FigH,hascoast,B,V)
end
#########################################

#########################################
"""
Struct: Colorbar output configuration
"""
mutable struct ColorSpec
    cmap
    crange::String
    B::String
    D::Bool
    I::Bool
    V::Bool
    Z::Bool
    # Constructor
    Claw.ColorSpec() = new()
    Claw.ColorSpec(cmap,crange,B,D,I,Z) = new(cmap,crange,B,D,I,Z,false)
    Claw.ColorSpec(cmap,crange,B,D,I,Z,V) = new(cmap,crange,B,D,I,Z,)
end
#########################################
