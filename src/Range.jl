######################################
### Function: range in simulation ####
######################################
function Range(tiles)
    xmin = minimum(getfield.(tiles, :xlow))
    ymin = minimum(getfield.(tiles, :ylow))
    ## the number of tiles
    ntile = length(tiles)

    global xmax = copy(xmin)
    global ymax = copy(ymin)
    for k = 1:ntile
        xmax = max(tiles[k].xlow+tiles[k].dx*tiles[k].mx, xmax)
        ymax = max(tiles[k].ylow+tiles[k].dy*tiles[k].my, ymax)
    end

    xrange = (xmin, xmax)
    yrange = (ymin, ymax)

    return (xrange, yrange)
end
######################################
