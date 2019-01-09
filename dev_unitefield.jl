include("loadamr.jl")
using Claw

using Printf
using GMT: GMT


t=5
tiles = stms.amr[t]
ntile = length(tiles)

Claw.RemoveCoarseUV!.(stms.amr);

J = "X12/9.6"
R="d-100/-80/16/32"
B = "a5f5 neSW"
V = false

xall, yall, pall = Claw.UniqueMeshVector(stms.amr[t]);
Δ = mindxdy(stms.amr[t])
G = GMT.surface([xall yall pall], R=R, I=Δ, T=1.0, V=V)

# makecpt script
cpttmp = "tmp.cpt"
GMT.gmt("makecpt -Cno_green -T950/1010/5 -D -V -I > $cpttmp")
cpt = GMT.gmt("read -Tc $cpttmp")
# remove tmp
rm(cpttmp)

GMT.grdimage(G, J=J, R=R, B=B, C=cpt, Q=true, V=V)

Dscale="jBR+w9.0/0.3+o-1.4/0.0" # Dj<justify>+w<length>/<width>+o<dx>/<dy>
Bcb="xa10g10 y+lhPa" # B option in psscale
GMT.colorbar!(J=J, R="", B=Bcb, C=cpt, D=Dscale, V=V)
GMT.coast!(J=J, R=R, B="", W="thinnest,white",V=V)
GMT.grdcontour!(G, J=J, R=R, B="", C="10", L="950/1010", W="thinnest", V=V)


# quiver
# -A
LineWidth = 0.01 # LineWidth
HeadLength = 0.10 # HeadLength
HeadSize = 0.05 # HeadSize

# -Se <velscale> / <confidence> / <fontsize>
Scale = 0.020 # velscale
Confidence = 0.0   # confidence
FontSize = 12    # fontsize

arrow = string(LineWidth)*"/"*string(HeadLength)*"/"*string(HeadSize)
Ssc=Scale
Sco=Confidence

tmpfile="tmpvelo.txt"
isfile(tmpfile) ? rm(tmpfile) : nothing
for k=1:ntile
    X,Y = Claw.meshtile(tiles[k])
    txtvelo_center(X,Y,tiles[k].u,tiles[k].v, skip=3*tiles[k].AMRlevel)
end

#Claw.psvelo(tmpfile,J=J,R=R,B=B,A=arrow,S="e$Ssc/$Sco/0",G="black",V=V)
Claw.psvelo!(tmpfile,J=J,R=R,B="",A=arrow,S="e$Ssc/$Sco/0",G="black",V=V)
rm(tmpfile)

scalefile="tmpscale.txt"
txtveloscale(-95, 30, 30.0, fname=scalefile);
Claw.psvelo!(scalefile, J="X12", R=R, B="", A=arrow, S="e$Ssc/$Sco/$FontSize", G="black", V=V)
rm(scalefile)



#=
using Plots: Plots
Plots.plotlyjs()
plt = Plots.plot()
for k = 1:length(tiles)
    xvec, yvec = Claw.meshline(tiles[k])
    Plots.scatter3d!(plt, xvec, yvec, vec(tiles[k].u), markersize=1, camera=(135,45))
    ind = isnan.(tiles[k].u)
    # any(ind) ? print("$k, ") : nothing
end
=#
