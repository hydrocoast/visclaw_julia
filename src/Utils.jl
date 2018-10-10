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
    if isa(var,Symbol) || isa(var,Plots.Font)
        var = ntuple(i -> var, nlen)
        return var
    end
    if (length(var) != nlen) && (length(var) != 1);
        error("The length of lc must correspond to that of gauge or 1.");
    end
    if length(var) == 1
        var = var*ones(nlen,1) |> vec
    end
    return var
end
############################################

"""
Get correct property name from the type of Claw.Tiles
"""
function varnameintile(tile::Claw.Tiles)
    # type check
    if isa(tile, Claw.patch)
        var = :eta
    elseif isa(tile, Claw.stormgrid)
        var = :slp
    else
        error("Invalid input argument, type of Claw.Tiles")
    end
    # return value
    return var
end
##########################################################

"""
Get Z values of cells including their margins
"""
function tilezmargin(tile::Claw.Tiles, var::Symbol; digits=4)
    ## set the boundary
    x = [tile.xlow, round(tile.xlow+tile.dx*tile.mx, digits=digits)]
    y = [tile.ylow, round(tile.ylow+tile.dy*tile.my, digits=digits)]

    ## grid info
    xvec = collect(LinRange(x[1]-0.5tile.dx, x[2]+0.5tile.dx, tile.mx+2));
    yvec = collect(LinRange(y[1]-0.5tile.dy, y[2]+0.5tile.dy, tile.my+2));
    xvec = round.(xvec, digits=digits)
    yvec = round.(yvec, digits=digits)
    ## adjust data
    val = zeros(tile.my+2,tile.mx+2)
    val[2:end-1,2:end-1] = getfield(tile, var)
    val[2:end-1,1] = val[2:end-1,2]
    val[2:end-1,end] = val[2:end-1,end-1]
    val[1,:] = val[2,:]
    val[end,:] = val[end-1,:]

    # return val
    return xvec, yvec, val
end
############################################################
"""
Get Z values of cells at the grid lines
"""
function tilez(tile::Claw.Tiles, var::Symbol; digits=4)
    xvec,yvec, val = Claw.tilezmargin(tile, var, digits=digits)
    itp = interpolate((yvec, xvec), val, Gridded(Linear()))

    ## set the boundary
    x = [tile.xlow, round(tile.xlow+tile.dx*tile.mx, digits=digits)]
    y = [tile.ylow, round(tile.ylow+tile.dy*tile.my, digits=digits)]

    xvec = collect(LinRange(x[1], x[2], tile.mx+1));
    yvec = collect(LinRange(y[1], y[2], tile.my+1));
    xvec = round.(xvec, digits=digits)
    yvec = round.(yvec, digits=digits)

    val = itp(yvec,xvec);

    # return val
    return xvec, yvec, val
end
############################################################
"""
Get Z values of cells at the center
"""
function tilezcenter(tile::Claw.Tiles, var::Symbol; digits=4)
    ## set the boundary
    x = [tile.xlow, round(tile.xlow+tile.dx*tile.mx, digits=digits)]
    y = [tile.ylow, round(tile.ylow+tile.dy*tile.my, digits=digits)]

    ## grid info
    xvec = collect(LinRange(x[1]+0.5tile.dx, x[2]-0.5tile.dx, tile.mx));
    yvec = collect(LinRange(y[1]+0.5tile.dy, y[2]-0.5tile.dy, tile.my));
    xvec = round.(xvec, digits=digits)
    yvec = round.(yvec, digits=digits)
    val = getfield(tile, var)

    # return val
    return xvec, yvec, val    
end
