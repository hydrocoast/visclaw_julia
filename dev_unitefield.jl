# include("loadamr.jl")

using GeometricalPredicates: GeometricalPredicates

tiles = stms.amr[1]
ntile = length(tiles)

levels = getfield.(tiles,:AMRlevel);
maxlevel=findmax(levels)[1]

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

function PolyRectangle(tile::Claw.Tiles)
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
#

i=1
#for i=1:ntile
    #
    # if tiles[i].AMRlevel == maxlevel; continue; end
    mp = tiles[i].mx*tiles[i].my
    xvec, yvec = meshline(tiles[i])
    allp = GeometricalPredicates.Point.(xvec,yvec);
    uuniq = vec(tiles[i].u)
    vuniq = vec(tiles[i].v)
    puniq = vec(tiles[i].slp)

    #
    existfiner = fill(false, (mp,ntile))
    for j = 1:ntile
        if i==j; continue; end
        if tiles[i].AMRlevel >= tiles[j].AMRlevel; continue; end
        println(j)
        # j=ntile
        rect = PolyRectangle(tiles[j])
        existfiner[:,j] = [GeometricalPredicates.inpolygon(rect, allp[k]) for k=1:mp]
    end

    delindex = any(existfiner, dims=2) |> vec
    deleteat!(xvec,delindex)
    deleteat!(yvec,delindex)
    deleteat!(uuniq,delindex)
    deleteat!(vuniq,delindex)
    deleteat!(puniq,delindex)

#end
