### Define Structs

###################################
## Struct:
##  storm data
###################################
struct stormgrid
    gridnumber::Int
    AMRlevel::Int
    mx::Int
    my::Int
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
## Struct:
##  data container of single patch
###################################
struct patch
    gridnumber::Int
    AMRlevel::Int
    mx::Int
    my::Int
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
## Struct:
##  time-seies of AMR data
###################################
struct amr
    nstep::Int
    timelap::AbstractVector{Float64}
    amr :: AbstractVector{Vector{Union{Claw.patch, Claw.stormgrid}}}
    # Constructor
    Claw.amr(nstep, timelap, amr) = new(nstep, timelap, amr)
end
###################################

###################################
## Struct:
##  Topography and Bathymetry
###################################
struct geometry
    ncols::Int
    nrows::Int
    xiter
    yiter
    topo::AbstractArray{Float64,2}
    # Constructor
    Claw.geometry(ncols, nrows, xiter, yiter, topo) =
             new(ncols, nrows, xiter, yiter, topo)
end
###################################

########################################
## Struct: parameters in geoclaw.data
########################################
struct param
    cs :: Int # coordinate system
    p0::Float64 # ambient pressure
    R :: Float64 # earth radious
    eta0 :: Float64 # sea level
    n ::Float64 # manning coafficient
    dmin :: Float64 # dry tolerance
    # Constructor
    Claw.param(cs,p0,R,eta0,n,dmin) =
          new(cs,p0,R,eta0,n,dmin)
end
########################################

########################################
## Struct: gauge
########################################
struct gauge
    id :: Int64 # gauge id
    nt :: Int64 # number of time step
    loc :: AbstractVector{Float64} # gauge location
    AMRlevel :: AbstractVector{Int64}
    time :: AbstractVector{Float64} # time
    eta :: AbstractVector{Float64} # surface
    aux # auxiliary
    # Constructor
    Claw.gauge(id,nt,loc,AMRlevel,time,eta)= new(id,nt,loc,AMRlevel,time,eta,nothing)
    Claw.gauge(id,nt,loc,AMRlevel,time,eta,aux)= new(id,nt,loc,AMRlevel,time,eta,aux)
end
########################################
