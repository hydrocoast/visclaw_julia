# Main rountine to print figures
# by Takuya Miyashita
# Doctoral student, Kyoto University, 2018

#if !(@isdefined AMR)
    include("src/AMR.jl")
#end

#################
### Main Topo ###
#################
fdir = "../clawpack-5.4.1/geoclaw/scratch";
fname = "etopo10min120W60W60S0S.asc"

geo = AMR.LoadTopo(joinpath(fdir,fname))

plt = AMR.PlotTopo(geo)
#plt = AMR.CoastalLines(geo)
