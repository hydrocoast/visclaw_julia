#########################################
"""
Struct: specification of topography output
"""
mutable struct FigureSpec
    J::String
    R::String
    B::String
    V::Bool
    # Constructor
    Claw.FigureSpec() = new()
    Claw.FigureSpec(B) = new("Xd","",B,false)
    Claw.FigureSpec(J,B) = new(J,"",B,false)
    Claw.FigureSpec(J,R,B) = new(J,R,B,false)
    Claw.FigureSpec(J,R,B,V) = new(J,R,B,V)
end
#########################################

#########################################
"""
Struct: specification of pscoast
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
Struct: specification of colorbar output
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

#########################################
"""
Struct: specification of contour
"""
mutable struct ContourSpec
    A
    C
    L
    W
    V::Bool

    # Constructor
    Claw.ContourSpec() = new(20,10,"950/1010","gray90",false)
    Claw.ContourSpec(A,C,L,W) = new(A,C,L,W,false)
    Claw.ContourSpec(A,C,L,W,V) = new(A,C,L,W,V)
end
#########################################




#########################################
"""
Struct: specification of arrow (psvelo)
"""
mutable struct ArrowSpec
    A     # -A (LineWidth,  HeadLength, HeadSize)
    S     # -Se <velscale> / <confidence> / <fontsize>
    G
    skip
    leg
    V::Bool
    # Constructor
    Claw.ArrowSpec() = new()
    Claw.ArrowSpec(A,S,G,skip,leg) = new(A,S,G,skip,leg,false)
    Claw.ArrowSpec(A,S,G,skip,leg,V) = new(A,S,G,skip,leg,V)
end
#########################################
