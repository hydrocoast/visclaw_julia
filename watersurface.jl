## Example: Case Chile2010 Tsunami
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018
if !(@isdefined CLAW); include("./CLAWPATH.jl"); end
if !any(occursin.("./src",LOAD_PATH)); push!(LOAD_PATH,"./src"); end
using Claw

using Printf: @printf, @sprintf
using Plots; Plots.pyplot()

## file paths
fdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output")
outdir = "./fig/chile2010"

### under construction
# Free water surface
    # load
    amrall = Claw.LoadSurface(fdir)
    amrdev = amrall.amr[1];
