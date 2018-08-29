### Define Structs

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
    xll::Float64
    yll::Float64
    topo::AbstractArray{Float64,2}
    # Constructor
    AMR.geometry(ncols, nrows, xll, yll, topo) =
    new(ncols, nrows, xll, yll, topo)
end
###################################
