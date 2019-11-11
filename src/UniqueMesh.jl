"""
generate meshgrid in 1-column
"""
function meshline(tile::Claw.Tiles)
    ## set the boundary
    x = [tile.xlow, tile.xlow+tile.dx*tile.mx]
    y = [tile.ylow, tile.ylow+tile.dy*tile.my]
    ## grid info
    xline = collect(Float64, x[1]+0.5tile.dx:tile.dx:x[2]-0.5tile.dx+1e-4)
    yline = collect(Float64, y[1]+0.5tile.dy:tile.dy:y[2]-0.5tile.dy+1e-4)
    xvec = repeat(xline, inner=(tile.my,1)) |> vec
    yvec = repeat(yline, outer=(tile.mx,1)) |> vec

    ## return values
    return xvec, yvec
end

"""
generate meshgrid
"""
function meshtile(tile::Claw.Tiles)
    ## set the boundary
    x = [tile.xlow, tile.xlow+tile.dx*tile.mx]
    y = [tile.ylow, tile.ylow+tile.dy*tile.my]
    ## grid info
    xline = collect(Float64, x[1]+0.5tile.dx:tile.dx:x[2]-0.5tile.dx+1e-4)
    yline = collect(Float64, y[1]+0.5tile.dy:tile.dy:y[2]-0.5tile.dy+1e-4)
    xmesh = repeat(xline', outer=(tile.my,1))
    ymesh = repeat(yline,  outer=(1,tile.mx))

    ## return values
    return xmesh, ymesh
end



"""
polygon data (rectangle) from a tile in AMR
"""
function polyrectangle(tile::Claw.Tiles)
    ## set the boundary
    x = [tile.xlow, tile.xlow+tile.dx*tile.mx]
    y = [tile.ylow, tile.ylow+tile.dy*tile.my]
    ## grid info
    xline = collect(Float64, x[1]+0.5tile.dx:tile.dx:x[2]-0.5tile.dx+1e-4)
    yline = collect(Float64, y[1]+0.5tile.dy:tile.dy:y[2]-0.5tile.dy+1e-4)

    ll = GeometricalPredicates.Point(xline[1], yline[1])
    lr = GeometricalPredicates.Point(xline[end], yline[1])
    ur = GeometricalPredicates.Point(xline[end], yline[end])
    ul = GeometricalPredicates.Point(xline[1], yline[end])
    poly = GeometricalPredicates.Polygon(ll, lr, ur, ul)

    return poly
end


"""
get points which are not overlapped by any of other tiles
"""
function UniqueMeshVector(tiles::Vector{Claw.Tiles})
    # number of the tiles
    ntile = length(tiles)
    # var
    var = Claw.keytile(tiles[1])

    ## deepest level
    levels = getfield.(tiles, :AMRlevel);
    maxlevel = maximum(levels)

    ## preallocate
    xall = Vector{Vector{Float64}}(undef,ntile)
    yall = Vector{Vector{Float64}}(undef,ntile)
    pall = Vector{Vector{Float64}}(undef,ntile)

    ## debugging
    # plt = Plots.plot()
    # i=1

    ## search points which are overlapped by the finer grids
    for i=1:ntile
        # numver of points in single tile
        mp = tiles[i].mx*tiles[i].my
        # all points in 1-column
        xvec, yvec = meshline(tiles[i])
        # convert type
        allp = GeometricalPredicates.Point.(xvec,yvec);
        # original values
        puniq = vec(getfield(tiles[i], var))

        if tiles[i].AMRlevel != maxlevel
            # preallocate
            existfiner = fill(false, (mp,ntile))

            # compare the location of the target tile to that of other tiles
            for j = 1:ntile
                if i==j; continue; end
                if tiles[i].AMRlevel >= tiles[j].AMRlevel; continue; end
                rect = polyrectangle(tiles[j])
                existfiner[:,j] = [GeometricalPredicates.inpolygon(rect, allp[k]) for k=1:mp]
            end

            ## delete points which the finer grids include
            delindex = any(existfiner, dims=2) |> vec
            deleteat!(xvec,delindex)
            deleteat!(yvec,delindex)
            deleteat!(puniq,delindex)
        end

        ## assign values
        xall[i] = xvec
        yall[i] = yvec
        pall[i] = puniq

        ## debugging
        # print("$i: $(length(xvec)) \n")
        # if i != ntile
        #     Plots.scatter!(plt, xvec,yvec, c=:auto)
        # end
    end

    ## concatenate points in all tiles
    xall = vcat(xall...)
    yall = vcat(yall...)
    pall = vcat(pall...)

    ## return values
    return xall, yall, pall
end



"""
get points which are not overlapped by any of other tiles
"""
function RemoveCoarseUV!(tiles::Vector{Claw.Tiles})
    # number of the tiles
    ntile = length(tiles)

    ## deepest level
    levels = getfield.(tiles,:AMRlevel);
    maxlevel=findmax(levels)[1]

    ## search points which are overlapped by the finer grids
    #i = 1
    for i=1:ntile
        # all points in 1-column
        xmesh, ymesh = Claw.meshtile(tiles[i])
        # convert type
        allp = GeometricalPredicates.Point.(xmesh,ymesh)

        #if tiles[i].AMRlevel != maxlevel; continue; end

        # compare the location of the target tile to that of other tiles
        #j=ntile
        for j = 1:ntile
            if i==j; continue; end
            if tiles[i].AMRlevel >= tiles[j].AMRlevel; continue; end
            rect = Claw.polyrectangle(tiles[j])

            for x = 1:tiles[i].mx
                for y = 1:tiles[i].my
                    inside = GeometricalPredicates.inpolygon(rect, allp[y,x])
                    if inside
                        tiles[i].u[y,x] = NaN
                        tiles[i].v[y,x] = NaN
                        ## debugging
                        # print("(i,j,y,x) = ($i,$j,$y,$x)\n")
                    end
                end
            end
        end
    end

    ## return values
    return
end
