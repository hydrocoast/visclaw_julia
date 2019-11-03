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
struct fgmaxval
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
    Claw.fgmaxval(h,th) = new(h, emptyF, emptyF, emptyF, emptyF,
                              th, emptyF, emptyF, emptyF, emptyF)
    Claw.fgmaxval(h,v,th,tv) = new(h, v, emptyF, emptyF, emptyF,
                                   th, tv, emptyF, emptyF, emptyF)
    Claw.fgmaxval(h,v,M,Mflux,hmin,th,tv,tM,tMflux,thmin) =
              new(h,v,M,Mflux,hmin,th,tv,tM,tMflux,thmin)
end
########################################



#########################################
"""
Struct: Output files configuration
"""
mutable struct OutputSpec
    figdir::String # save directory
    prefix::String # prefix for time-series plot
    start_number::Int64 # initial step number for time-series plot
    ext::String # .ps, .eps, .png (.svg, .gif)
    dpi::Int64 # only .png and .gif
    fps::Int64 # only .gif
    remove_old::Bool # remove old files if true
    # Constructor
    Claw.OutputSpec() = new(".","step",0,".eps",400,4,true)
    Claw.OutputSpec(figdir) = new(figdir,"step",0,".eps",400,4,true)
    Claw.OutputSpec(figdir,prefix) = new(figdir,prefix,0,".eps",400,4,true)
    Claw.OutputSpec(figdir,prefix,start_number) = new(figdir,prefix,start_number,".eps",400,4,true)
    Claw.OutputSpec(figdir,prefix,start_number,ext,dpi) = new(figdir,prefix,start_number,ext,dpi,4,true)
    Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,remove_old) = new(figdir,prefix,start_number,ext,dpi,0,remove_old)
    Claw.OutputSpec(figdir,prefix,start_number,ext,dpi,fps,remove_old) = new(figdir,prefix,start_number,ext,dpi,fps,remove_old)
end
#########################################

#########################################
"""
Struct: Time in unit or datetime
"""
mutable struct TimeSpec
    origin::Union{Dates.DateTime,String}
    format::String
    # Constructor
    Claw.TimeSpec() = new("hour","%0.1f")
    Claw.TimeSpec(origin) = isa(origin,Dates.DateTime) ? new(origin,"yyyy/mm/dd HH:MM") : new(origin,"%0.1f")
    Claw.TimeSpec(origin,format) = new(origin,format)
end
#########################################
