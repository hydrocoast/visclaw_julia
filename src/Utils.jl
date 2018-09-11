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

############################################
### Function: check arguments and resize ###
############################################
function chkarglength!(var, nlen::Int)
    # Scolor Symbol
    if isa(var,Symbol); var = ntuple(i -> var, nlen); return var; end
    if (length(var) != nlen) && (length(var) != 1);
        error("The length of lc must correspond to that of gauge or 1.");
    end
    if length(var) == 1
        var = var*ones(nlen,1) |> vec
    end
    return var
end
############################################
