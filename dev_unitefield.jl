include("loadamr.jl")
using Claw


using GMT: GMT

function mindxdy(tiles::Vector{Claw.Tiles})
    dxs = getfield.(tiles,:dx);
    dx=findmin(dxs)[1]
    dys = getfield.(tiles,:dy);
    dy=findmin(dys)[1]

    Δ = min(dx,dy)
end

function txtvelo_center(LON,LAT,Ux,Uy; skip=1::Real)
    tmpname = "tmpwind.txt"
    numel = length(LON[1:skip:end,1:skip:end])
    outdat = [vec(LON[1:skip:end,1:skip:end]) vec(LAT[1:skip:end,1:skip:end]) vec(Ux[1:skip:end,1:skip:end]) vec(Uy[1:skip:end,1:skip:end]) repeat([0.0], inner=(numel,4)) ]
    open(tmpname,"w") do file
        Base.print_array(file, outdat)
    end

    return tmpname
end

t=5
xall, yall, pall, uall, vall = Claw.UniqueMeshVector(stms.amr[t]);
Δ = mindxdy(stms.amr[1])

J = "X12/9.6"
B = "a10f10 neSW"
R="d-100/-70/8/32"
V=true

G = GMT.surface([vcat(xall...) vcat(yall...) vcat(pall...)], R=R, I=Δ, T=1.0, V=V)

# makecpt script
cpttmp = "tmp.cpt"
GMT.gmt("makecpt -Cno_green -T945/1005/5 -D -V -I > $cpttmp")
cpt = GMT.gmt("read -Tc $cpttmp")
# remove tmp
rm(cpttmp)

GMT.grdimage(G, J=J, R=R, B=B, C=cpt, Q=true, V=V)

Dscale="jBR+w9.0/0.3+o-1.0/0.0" # Dj<justify>+w<length>/<width>+o<dx>/<dy>
Bcb="xa10g10 y+lhPa" # B option in psscale
GMT.colorbar!(J=J, R="", B=Bcb, C=cpt, D=Dscale, V=V)
GMT.coast!(J=J, R=R, B="", W="thinnest,white",V=V)
GMT.grdcontour!(G, J=J, R=R, B="", C="10", L="945/1005", W="thinnest", V=V)

#k = 1
#tmpname = txtvelo_center(xall[k], yall[k], uall[k], vall[k], skip=)
