## Example: Case Chile2010 Tsunami
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018
if !(@isdefined CLAW); include("./CLAWPATH.jl"); end
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

using Printf: @printf, @sprintf
using GMT:GMT

## file paths
fdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
outdir = "./fig/chile2010"
### under construction
# Free water surface
    # load
    amrall = Claw.LoadSurface(fdir)
    titlestr = Claw.sec2str(amrall.timelap, "hour", fmt="%5.1f")
    # GMT make cpt
    cpt = Claw.tilecpt(V=true)

    # basic options
    proj="X10/10"
    region="d-120/-60/-60/0"
    frame="a15f15 neSW"
    # water surface elavation
    Claw.AMRSurf(amrall, cpt, J=proj, R=region, B=frame, V=false);
    # Coastline
    Claw.AMRCoast!(amrall, R=region, G="gray80", V=false);
    # Colorbar
    Claw.AMRColorbar!(amrall, cpt, B="xa0.2f0.1 y+l(m)", D=Claw.cboptDj(), V=false)
    # Time
    Claw.AMRTitle!(amrall, titlestr, V=false)
    # Convert file format
    Claw.ps2eps_series(amrall.nstep)
    Claw.eps2png_series(amrall.nstep, reserve=false)
