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

    return xvec, yvec
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

    ## deepest level
    levels = getfield.(tiles,:AMRlevel);
    maxlevel=findmax(levels)[1]

    ## preallocate
    xall = Vector{Vector{Float64}}(undef,ntile)
    yall = Vector{Vector{Float64}}(undef,ntile)
    uall = Vector{Vector{Float64}}(undef,ntile)
    vall = Vector{Vector{Float64}}(undef,ntile)
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
        uuniq = vec(tiles[i].u)
        vuniq = vec(tiles[i].v)
        puniq = vec(tiles[i].slp)

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
            deleteat!(uuniq,delindex)
            deleteat!(vuniq,delindex)
            deleteat!(puniq,delindex)
        end

        ## assign values
        xall[i] = xvec
        yall[i] = yvec
        uall[i] = uuniq
        vall[i] = vuniq
        pall[i] = puniq

        ## debugging
        # print("$i: $(length(xvec)) \n")
        # if i != ntile
        #     Plots.scatter!(plt, xvec,yvec, c=:auto)
        # end
    end

    ## concatenate points in all tiles
    #xvec = vcat(xall...)
    #yvec = vcat(yall...)
    #pvec = vcat(pall...)
    # uall = vcat(uall...)
    # vall = vcat(vall...)



    ## return values
    return xall, yall, pall, uall, vall
end
