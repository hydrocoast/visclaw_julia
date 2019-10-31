arrowhead_default=(0.5,0.5)
arrowlen_default=0.05

###########################################
## Function: Draw wind field with arrows
###########################################
function PlotsWindArrow!(plt, tiles::AbstractVector{Claw.Tiles}, dc=5::Int64;
                         len=arrowlen_default, head=arrowhead_default)
    ## the number of tiles
	ntile = length(tiles)

	## display each tile
    for i = 1:ntile
        ## set the boundary
        x = [tiles[i].xlow, tiles[i].xlow+tiles[i].dx*tiles[i].mx]
        y = [tiles[i].ylow, tiles[i].ylow+tiles[i].dy*tiles[i].my]
        ##
        xq = collect(x[1]:tiles[i].dx:x[2])
        yq = collect(y[1]:tiles[i].dy:y[2])

        X = repeat(xq[1:dc:end], inner=(length(yq[1:dc:end]), 1))
        Y = repeat(yq[1:dc:end], outer=(length(xq[1:dc:end]), 1))
        U = len*vec(tiles[i].u[1:dc:end,1:dc:end])
        V = len*vec(tiles[i].v[1:dc:end,1:dc:end])

        plt = Plots.quiver!(plt, X, Y, quiver=(U, V),
                            arrow=Plots.arrow(:closed, :head, head[1], head[2]),
                            color=:black, colorbar=false)
    end

    ## return
    return plt
end
###########################################
PlotsWindArrow(tiles, dc=5::Int64; len=arrowlen_default, head=arrowhead_default) =
PlotsWindArrow!(Plots.plot(), tiles, dc, len=len, head=head)
###########################################
