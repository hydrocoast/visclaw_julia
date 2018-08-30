### Define Structs

###################################
## Struct:
##  storm data
###################################
mutable struct stormgrid
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
    AMR.stormgrid(gridnumber, AMRlevel, mx, my, xlow, ylow, dx, dy, u, v, slp) =
    new(gridnumber, AMRlevel, mx, my, xlow, ylow, dx, dy, u, v, slp)
end
###################################

###################################
## Struct:
##  data container of single patch
###################################
mutable struct patch
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
    AMR.patch(gridnumber, AMRlevel, mx, my, xlow, ylow, dx, dy, eta) =
    new(gridnumber, AMRlevel, mx, my, xlow, ylow, dx, dy, eta)
end


###################################
## Struct:
##  time-seies of AMR data
###################################
mutable struct amr
    nstep::Int
    timelap::AbstractVector{Float64}
    amr::AbstractVector{AbstractVector{AMR.patch}}
    # Constructor
    AMR.amr(nstep, timelap, amr) = new(nstep, timelap, amr)
end
###################################

###################################
## Struct:
##  Topography and Bathymetry
###################################
mutable struct geometry
    ncols::Int
    nrows::Int
    xiter
    yiter
    topo::AbstractArray{Float64,2}
    # Constructor
    AMR.geometry(ncols, nrows, xiter, yiter, topo) =
             new(ncols, nrows, xiter, yiter, topo)
end
###################################
