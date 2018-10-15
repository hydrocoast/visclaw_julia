#########################################
"""
Struct: Topography output configuration
"""
mutable struct FigureSpec
    dir::String
    figdir::String
    proj::String
    B::String
    V::Bool
    # Constructor
    Claw.FigureSpec() = new()
    Claw.FigureSpec(dir,figdir,proj,B) = new(dir,figdir,proj,B,false)
    Claw.FigureSpec(dir,figdir,proj,B,V) = new(dir,figdir,proj,B,V)
end
#########################################

#########################################
"""
Struct: pscoast configuration
"""
mutable struct CoastSpec
    hascoast::Bool
    D::String
    W::String
    G::String
    S::String
    V::Bool
    # Constructor
    Claw.CoastSpec() = new(false,"","","","",false)
    Claw.CoastSpec(hascoast,D,W,G,S,V) = new(hascoast,D,W,G,S,V)
end
#########################################

#########################################
"""
Struct: Colorbar output configuration
"""
mutable struct ColorSpec
    cmap::Symbol
    crange::String
    loc::String
    cbsize::Tuple{Real,Real}
    offset::Tuple{Real,Real}
    B::String
    D::Bool
    I::Bool
    V::Bool
    Z::Bool
    # Constructor
    Claw.ColorSpec() = new()
    Claw.ColorSpec(cmap,crange,loc,cbsize,offset,B) = new(cmap,crange,loc,cbsize,offset,B,true,false,false,false)
    Claw.ColorSpec(cmap,crange,loc,cbsize,offset,B,D) = new(cmap,crange,loc,cbsize,offset,B,D,false,false,false)
    Claw.ColorSpec(cmap,crange,loc,cbsize,offset,B,D,I) = new(cmap,crange,loc,cbsize,offset,B,D,I,false,false)
    Claw.ColorSpec(cmap,crange,loc,cbsize,offset,B,D,I,Z) = new(cmap,crange,loc,cbsize,offset,B,D,I,Z,false)
    Claw.ColorSpec(cmap,crange,loc,cbsize,offset,B,D,I,Z,V) = new(cmap,crange,loc,cbsize,offset,B,D,I,Z,V)
end
#########################################
