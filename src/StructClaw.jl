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
 data container of single patch
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

###################################
"""
Struct:
 Topography and Bathymetry
"""
struct geometry
    ncols :: Int64
    nrows :: Int64
    x :: Vector{Float64}
    y :: Vector{Float64}
    topo :: AbstractArray{Float64,2}
    # Constructor
    Claw.geometry(ncols, nrows, x, y, topo) =
              new(ncols, nrows, x, y, topo)
end
###################################

##########################################################
"""
Struct:
 seafloor deformation for tsunami computation
"""
struct dtopo
    mx :: Int64
    my :: Int64
    x :: Vector{Float64}
    y :: Vector{Float64}
    mt :: Int64
    t0 :: Float64
    dt :: Float64
    deform :: AbstractArray{Float64,2}
    # Constructor
    Claw.dtopo(mx,my,x,y,mt,t0,dt,deform) = new(mx,my,x,y,mt,t0,dt,deform)
end
##########################################################

########################################
"""
Struct: parameters in geoclaw.data
"""
struct param
    cs :: Int64 # coordinate system
    p0::Float64 # ambient pressure
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
Struct: gauge data
"""
struct gauge
    label :: String # Name
    id :: Int64 # gauge id
    nt :: Int64 # number of time step
    loc :: AbstractVector{Float64} # gauge location
    AMRlevel :: AbstractVector{Int64}
    time :: AbstractVector{Float64} # time
    eta :: AbstractVector{Float64} # surface
    aux # auxiliary
    # Constructor
    Claw.gauge(label,id,nt,loc,time,eta) = new(label,id,nt,loc,[],time,eta,nothing)
    Claw.gauge(label,id,nt,loc,AMRlevel,time,eta) = new(label,id,nt,loc,AMRlevel,time,eta,nothing)
    Claw.gauge(label,id,nt,loc,AMRlevel,time,eta,aux)= new(label,id,nt,loc,AMRlevel,time,eta,aux)
end
########################################
