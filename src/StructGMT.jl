#########################################
"""
Struct: Topography output configuration
"""
mutable struct FigureSpec
    dir::String
    J::String
    R::String
    B::String
    V::Bool
    # Constructor
    Claw.FigureSpec() = new()
    Claw.FigureSpec(dir,B) = new(dir,"Xd","",B,false)
    Claw.FigureSpec(dir,B,V) = new(dir,"Xd","",B,V)
    Claw.FigureSpec(dir,J,B) = new(dir,J,"",B,false)
    Claw.FigureSpec(dir,J,B,V) = new(dir,J,"",B,V)
    Claw.FigureSpec(dir,J,R,B) = new(dir,J,R,B,false)
    Claw.FigureSpec(dir,J,R,B,V) = new(dir,J,R,B,V)
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
    Dscale::String
    B::String
    D::Bool
    I::Bool
    V::Bool
    Z::Bool
    # Constructor
    Claw.ColorSpec() = new()
    Claw.ColorSpec(cmap,crange,Dscale,B) = new(cmap,crange,Dscale,B,true,false,false,false)
    Claw.ColorSpec(cmap,crange,Dscale,B,D) = new(cmap,crange,Dscale,B,D,false,false,false)
    Claw.ColorSpec(cmap,crange,Dscale,B,D,I) = new(cmap,crange,Dscale,B,D,I,false,false)
    Claw.ColorSpec(cmap,crange,Dscale,B,D,I,Z) = new(cmap,crange,Dscale,B,D,I,Z,false)
    Claw.ColorSpec(cmap,crange,Dscale,B,D,I,Z,V) = new(cmap,crange,Dscale,B,D,I,Z,V)
end
#########################################
