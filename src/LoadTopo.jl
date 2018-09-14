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
## Function: load topography
#################################
function LoadTopo(filename::String; topotype=3::Int)
    ## check args
    if !isfile(filename); error("file $filename is not found."); end;
    if (topotype!=2) & (topotype!=3); error("Invalid number of topotype"); end

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
    xiter = collect(Float64, LinRange(xll, xll+(ncols-1)*cellsize+1e-5, ncols))
    yiter = collect(Float64, LinRange(yll, yll+(nrows-1)*cellsize+1e-5, nrows))

    # check topotype
    tmp = replace(dataorg[1], r"^\s+" => "")
    tmp = replace(tmp, "," => " ") # for csv data
    tmp = split(tmp, r"\s+")
    if isempty(tmp[end]); tmp=tmp[1:end-1]; end
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
            line = replace(dataorg[k], r"^\s+" => "")
            line = replace(line, "," => " ") # for csv data
            line = split(line, r"\s+")
            if isempty(line[end]); line=line[1:end-1]; end
            topo[k,:] = parse.(Float64, line)
        end
    end
    topo[topo.==nodata] .= NaN ## replace nodate to NaN
    topo = reverse(topo, dims=1) ## flip
    geo = Claw.geometry(ncols, nrows, xiter, yiter, topo)

    return geo
end
#################################
