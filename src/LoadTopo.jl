#=
This module doesn't support topography composed of multiple files.
=#
#################################
## Function: read topo.data
#################################
function topodata(dirname::String)
    ## check args
    if !isdir(dirname); error("A directory $dirname is not found."); end;

    ## read topodata
    filename= joinpath(dirname,"topo.data")
    f = open(filename,"r")
    topodata = readlines(f)
    close(f)
    ntopo = parse(Int64, topodata[8][1:2]) # line 8, =: ntopofiles
    topofile = replace(topodata[10],r"[\'\s]" => "") # line 10, topofile 1

    return topofile, ntopo
end
#################################

#################################
## Function: read dtopo.data
#################################
function dtopodata(dirname::String)
    ## check args
    if !isdir(dirname); error("A directory $dirname is not found."); end;

    ## read topodata
    filename= joinpath(dirname,"dtopo.data")
    if !isfile(filename); error("File $filename is not found."); end
    f = open(filename,"r")
    dtopodata = readlines(f)
    close(f)
    ndtopo = parse(Int64, dtopodata[7][1:2]) # line 8, =: ntopofiles
    dtopofile = replace(dtopodata[10],r"[\'\s]" => "") # line 10, topofile 1

    return dtopofile, ndtopo
end
#################################


#################################
## Function: load topography
#################################
function LoadTopo(filename::String; topotype=3::Int)
    ## check args
    if !isfile(filename); error("file $filename is not found."); end;
    if (topotype!=2) & (topotype!=3); error("Invalid topotype"); end

    ## separator in regular expression
    regex = r"([+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?)"
    ## open topofile
    f = open(filename,"r")
        ## read header
        ncols = parse(Int64, match(regex, readline(f)).captures[1])
        nrows = parse(Int64, match(regex, readline(f)).captures[1])
        xll = parse(Float64, match(regex, readline(f)).captures[1])
        yll = parse(Float64, match(regex, readline(f)).captures[1])
        cellsize = parse(Float64, match(regex, readline(f)).captures[1])
        nodata = match(regex, readline(f)).captures[1]
        ## read topodata
        dataorg = readlines(f)
    ## close topofile
    close(f)

    ## meshgrid
    x = collect(Float64, LinRange(xll, xll+(ncols-1)*cellsize+1e-5, ncols))
    y = collect(Float64, LinRange(yll, yll+(nrows-1)*cellsize+1e-5, nrows))

    # check topotype
    tmp = replace(dataorg[1], r"^\s+|,?\s+$" => "")
    tmp = replace(tmp, "," => " ") # for csv data
    tmp = split(tmp, r"\s+",keepempty=false)
    tmp = parse.(Float64, tmp)
    if length(tmp) == 1
        println("topotype is assumed as 2.")
        topotype = 2;
    end

    ## assign topography
    if topotype == 2
        topo = parse.(Float64, dataorg)
        topo = reshape(topo, (ncols, nrows))
        topo = permutedims(topo,[2 1])
    elseif topotype == 3
        topo = zeros(nrows, ncols)
        for k = 1:nrows
            line = replace(dataorg[k], r"^\s+|,?\s+$" => "")
            line = replace(line, "," => " ") # for csv data
            line = split(line, r"\s+",keepempty=false)
            topo[k,:] = parse.(Float64, line)
        end
    end
    topo[topo.==nodata] .= NaN ## replace nodate to NaN
    topo = reverse(topo, dims=1) ## flip
    geo = Claw.geometry(ncols, nrows, x, y, topo)

    return geo
end
#################################

#########################################
## Function: load seafloor deformation
#########################################
function LoadDeform(filename::String, topotype=3::Int)
    ## check args
    if !isfile(filename); error("file $filename is not found."); end;
    if (topotype!=2) & (topotype!=3); error("Invalid topotype"); end

    ## separator in regular expression
    regex = r"([+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?)"
    ## open topofile
    f = open(filename,"r")
        ## read header
        mx = parse(Int64, match(regex, readline(f)).captures[1])
        my = parse(Int64, match(regex, readline(f)).captures[1])
        mt = parse(Int64, match(regex, readline(f)).captures[1])
        xlow = parse(Float64, match(regex, readline(f)).captures[1])
        ylow = parse(Float64, match(regex, readline(f)).captures[1])
        t0 = parse(Float64, match(regex, readline(f)).captures[1])
        dx = parse(Float64, match(regex, readline(f)).captures[1])
        dy = parse(Float64, match(regex, readline(f)).captures[1])
        dt = parse(Float64, match(regex, readline(f)).captures[1])
        ## read topodata
        dataorg = readlines(f)
    ## close topofile
    close(f)

    ## meshgrid
    x = collect(Float64, LinRange(xlow, xlow+(mx-1)*dx+1e-5, mx))
    y = collect(Float64, LinRange(ylow, ylow+(my-1)*dy+1e-5, my))

    # check topotype
    tmp = replace(dataorg[1], r"^\s+|,?\s+$" => "") # equivalent to strip?
    tmp = replace(tmp, "," => " ") # for csv data
    tmp = split(tmp, r"\s+",keepempty=false)
    tmp = parse.(Float64, tmp)
    if length(tmp) == 1
        println("topotype is assumed as 2.")
        topotype = 2;
    end

    ## assign topography
    if topotype == 2
        deform = parse.(Float64, dataorg)
        deform = reshape(topo, (mx, my))
        deform = permutedims(topo,[2 1])
    elseif topotype == 3
        deform = zeros(mx, my)
        for k = 1:my
            line = replace(dataorg[k], r"^\s+|,?\s+$" => "")
            line = replace(line, "," => " ") # for csv data
            line = split(line, r"\s+",keepempty=false)
            deform[k,:] = parse.(Float64, line)
        end
    end
    deform = reverse(deform, dims=1) ## flip
    #deform[abs.(deform).<1e-2] .= NaN
    dtopodata = Claw.dtopo(mx,my,x,y,mt,t0,dt,deform)

    return dtopodata
end
#########################################
