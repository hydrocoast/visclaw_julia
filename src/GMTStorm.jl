function grdpres(tiles::Vector{Claw.Tiles}; R="", T=1.0, V=true::Bool)
    # unite
    xall, yall, pall = Claw.UniqueMeshVector(tiles)
    # makegrd
    Δ = Claw.mindxdy(tiles)
    G = GMT.surface([xall yall pall], R=R, I=Δ, T=T, V=V)
    # return value
    return G
end

function txtwind(tiles::Vector{Claw.Tiles}; skip=3::Int)
    tmpfile="tmpvelo.txt"
    isfile(tmpfile) ? rm(tmpfile) : nothing

    for k=1:length(tiles)
        X,Y = Claw.meshtile(tiles[k])
        txtvelo_center(X,Y,tiles[k].u,tiles[k].v, skip=skip*tiles[k].AMRlevel, fname=tmpfile)
    end

    return tmpfile

end
