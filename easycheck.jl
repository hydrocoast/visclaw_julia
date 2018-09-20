# easy checker
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018
if !(@isdefined CLAW)
    include("./CLAWPATH.jl")
end
if !(@isdefined Claw)
    include("src/Claw.jl")
end

## target directory
fdir = joinpath(CLAW,"geoclaw/examples/tsunami/chile2010/_output"); clim=(-0.5,0.5); cmap=:coolwarm
#fdir = joinpath(CLAW,"geoclaw/examples/storm-surge/ike/_output"); clim=(0.0,2.0); cmap=:rainbow

# sea surface
amrall = Claw.LoadSurface(fdir)
plt = Claw.SurfacebyStep(amrall, clim=clim, cmap=cmap);
