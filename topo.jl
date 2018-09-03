# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

#if !(@isdefined AMR)
    include("src/AMR.jl")
#end

#################
### Main Topo ###
#################
topodir = "../clawpack-5.4.1/geoclaw/scratch";
toponame = "etopo10min120W60W60S0S.asc"
geo = AMR.LoadTopo(joinpath(topodir,toponame));

# coastal lines
#plt = AMR.CoastalLines(geo)
# topography
Plots.clibrary(:cmocean)
plt = AMR.PlotTopo(geo, clim=(-6000,6000))
