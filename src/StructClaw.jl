### Define Structs
abstract type Tiles end

###################################
"""
Struct:
 storm data
"""
struct stormgrid <: Claw.Tiles
    gridnumber::Int64
    AMRlevel::Int64
    mx::Int64
    my::Int64
    xlow::Float64
    ylow::Float64
    dx::Float64
    dy::Float64
    u :: AbstractArray{Float64,2}
    v :: AbstractArray{Float64,2}
    slp :: AbstractArray{Float64,2}
    # Constructor
    Claw.stormgrid(gridnumber, AMRlevel, mx, my, xlow, ylow, dx, dy, u, v, slp) =
    new(gridnumber, AMRlevel, mx, my, xlow, ylow, dx, dy, u, v, slp)
end
###################################

###################################
"""
Struct:
 current u, v with patches
"""
struct uv <: Claw.Tiles
    gridnumber::Int64
    AMRlevel::Int64
    mx::Int64
    my::Int64
    xlow::Float64
    ylow::Float64
    dx::Float64
    dy::Float64
    u :: AbstractArray{Float64,2}
    v :: AbstractArray{Float64,2}
    vel :: AbstractArray{Float64,2}
    # Constructor
    Claw.uv(gridnumber, AMRlevel, mx, my, xlow, ylow, dx, dy, u, v, vel) =
    new(gridnumber, AMRlevel, mx, my, xlow, ylow, dx, dy, u, v, vel)
end
###################################

###################################
"""
Struct:
 eta with patches
"""
struct patch <: Claw.Tiles
    gridnumber::Int64
    AMRlevel::Int64
    mx::Int64
    my::Int64
    xlow::Float64
    ylow::Float64
    dx::Float64
    dy::Float64
    eta::AbstractArray{Float64,2}
    # Constructor
    Claw.patch(gridnumber, AMRlevel, mx, my, xlow, ylow, dx, dy, eta) =
    new(gridnumber, AMRlevel, mx, my, xlow, ylow, dx, dy, eta)
end
###################################

###################################
"""
Struct:
 time-seies of AMR data
"""
struct AMR
    nstep::Int64
    timelap::AbstractVector{Float64}
    amr :: AbstractVector{Vector{Claw.Tiles}}
    # Constructor
    Claw.AMR(nstep, timelap, amr) = new(nstep, timelap, amr)
end
###################################

abstract type AbstractTopo end
###################################
"""
Struct:
 topography and bathymetry
"""
struct Topo <: AbstractTopo
    ncols :: Int64
    nrows :: Int64
    x :: Vector{Float64}
    y :: Vector{Float64}
    dx :: Float64
    dy :: Float64
    elevation :: AbstractArray{Float64,2}
    # Constructor
    Claw.Topo(ncols, nrows, x, y, dx, dy, elevation) =
          new(ncols, nrows, x, y, dx, dy, elevation)
end
###################################

##########################################################
"""
Struct:
 seafloor deformation for tsunami computation
"""
struct DTopo <: AbstractTopo
    mx :: Int64
    my :: Int64
    x :: Vector{Float64}
    y :: Vector{Float64}
    dx :: Float64
    dy :: Float64
    mt :: Int64
    t0 :: Float64
    dt :: Float64
    deform :: AbstractArray{Float64,2}
    # Constructor
    Claw.DTopo(mx,my,x,y,dx,dy,mt,t0,dt,deform) = new(mx,my,x,y,dx,dy,mt,t0,dt,deform)
end
##########################################################

########################################
"""
Struct: parameters in geoclaw.data
"""
struct param
    cs :: Int64 # coordinate system
    p0:: Float64 # ambient pressure
    R :: Float64 # earth radious
    eta0 :: Float64 # sea level
    n ::Float64 # manning coafficient
    dmin :: Float64 # dry tolerance
    # Constructor
    Claw.param() = new(2,101300.0,6367500.0,0.0,0.025,0.001)
    Claw.param(cs,p0,R,eta0,n,dmin) = new(cs,p0,R,eta0,n,dmin)
end
########################################

########################################
"""
Struct: parameters in surge.data
"""
struct surge
    windindex::Int64
    slpindex::Int64
    stormtype::Int64
    landfall::Float64
    # Constructor
    Claw.surge() = new(5,7,1,0.0)
    Claw.surge(windindex,slpindex,stormtype,landfall) = new(windindex,slpindex,stormtype,landfall)
end
########################################

########################################
"""
Struct: gauge data
"""
mutable struct gauge
    label :: String # Name
    id :: Int64 # gauge id
    nt :: Int64 # number of time step
    loc :: AbstractVector{Float64} # gauge location
    AMRlevel :: AbstractVector{Int64}
    time :: AbstractVector{Float64} # time
    eta :: AbstractVector{Float64} # surface
    # Constructor
    Claw.gauge(label,id,nt,loc,AMRlevel,time,eta) = new(label,id,nt,loc,AMRlevel,time,eta)
end
########################################

########################################
"""
Struct: fgmax grid
"""
struct fgmaxgrid
    FGid :: Int64
    file :: String
    nval :: Int64
    nx :: Int64
    ny :: Int64
    xlims :: Tuple{Float64,Float64}
    ylims :: Tuple{Float64,Float64}

    # Constructor
    Claw.fgmaxgrid(FGid,file,nval) = new(FGid,file,nval,0,0,(0.0,0.0),(0.0,0.0))
    Claw.fgmaxgrid(FGid,file,nval,nx,ny,xlims,ylims) = new(FGid,file,nval,nx,ny,xlims,ylims)
end
########################################

########################################
"""
Struct: fgmax values
"""
mutable struct fgmaxval
    bath :: AbstractArray{Float64,2}
    h :: AbstractArray{Float64,2}
    v :: AbstractArray{Float64,2}
    M :: AbstractArray{Float64,2}
    Mflux :: AbstractArray{Float64,2}
    hmin :: AbstractArray{Float64,2}
    th :: AbstractArray{Float64,2}
    tv :: AbstractArray{Float64,2}
    tM :: AbstractArray{Float64,2}
    tMflux :: AbstractArray{Float64,2}
    thmin :: AbstractArray{Float64,2}

    # Constructor
    Claw.fgmaxval(bath,h,th) = new(bath,h, emptyF, emptyF, emptyF, emptyF,
                                   th, emptyF, emptyF, emptyF, emptyF)
    Claw.fgmaxval(bath,h,v,th,tv) = new(bath, h, v, emptyF, emptyF, emptyF,
                                        th, tv, emptyF, emptyF, emptyF)
    Claw.fgmaxval(bath,h,v,M,Mflux,hmin,th,tv,tM,tMflux,thmin) =
              new(bath,h,v,M,Mflux,hmin,th,tv,tM,tMflux,thmin)
end
########################################
