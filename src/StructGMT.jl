#########################################
"""
Struct: Topography output configuration
"""
mutable struct FigureSpec
    dir::String
    figdir::String
    J::String
    R::String
    B::String
    V::Bool
    # Constructor
    Claw.FigureSpec() = new()
    Claw.FigureSpec(dir,figdir,B) = new(dir,figdir,"Xd","",B,false)
    Claw.FigureSpec(dir,figdir,B,V) = new(dir,figdir,"Xd","",B,V)
    Claw.FigureSpec(dir,figdir,J,B) = new(dir,figdir,J,"",B,false)
    Claw.FigureSpec(dir,figdir,J,B,V) = new(dir,figdir,J,"",B,V)
    Claw.FigureSpec(dir,figdir,J,R,B) = new(dir,figdir,J,R,B,false)
    Claw.FigureSpec(dir,figdir,J,R,B,V) = new(dir,figdir,J,R,B,V)
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

#########################################
"""
Struct: Output files configuration
"""
mutable struct OutputSpec
    prefix::String
    start_number::Int64
    ext::String
    remove_old::Bool
    # Constructor
    Claw.OutputSpec() = new("step",0,".eps",true)
    Claw.OutputSpec(prefix) = new(prefix,0,".eps",true)
    Claw.OutputSpec(prefix,start_number) = new(prefix,start_number,".eps",true)
    Claw.OutputSpec(prefix,start_number,ext) = new(prefix,start_number,ext,true)
    Claw.OutputSpec(prefix,start_number,ext,remove_old) = new(prefix,start_number,ext,remove_old)
end
#########################################
