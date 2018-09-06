# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

#if !(@isdefined Claw)
    include("src/Claw.jl")
#end

#################
### Main Topo ###
#################
topodir = "../clawpack-5.4.1/geoclaw/scratch";
toponame = "etopo10min120W60W60S0S.asc"
geo = Claw.LoadTopo(joinpath(topodir,toponame));

# coastal lines
#plt = Claw.CoastalLines(geo)
# topography
Plots.clibrary(:cmocean)
plt = Claw.PlotTopo(geo, clim=(-6000,6000))
