### Functions to read ascii file and assign variables.
### Now available to read fort.qxxxx, fort.txxxx and fort.axxxx.
### Dataset is assigned into the type of stcuct.

#################################
## Function: fort.qxxxx reader
#################################
function LoadFortq(filename::String, ncol::Int; kw="surface"::String, eta0=0.0::Float64)
    ## file open
    f = open(filename,"r")
    txtorg = readlines(f)
    close(f) #close

    ## count the number of lines and grids
    nlineall = length(txtorg)
    idx = occursin.("grid_number",txtorg)
    ngrid = length(txtorg[idx])

    if kw=="surface"
        amr = Array{AMR.patch}(undef,ngrid) ## preallocate
    elseif kw=="storm"
        amr = Array{AMR.stormgrid}(undef,ngrid)
    else
        error("kwarg kw is invalid")
    end

    l = 1
    i = 1
    while l < nlineall
        ## read header
        #header = txtorg[1:8]
        header = txtorg[l:l+7]
        gridnumber = parse(Int64, header[1][1:6])
        AMRlevel = parse(Int64, header[2][1:6])
        mx = parse(Int64, header[3][1:6])
        my = parse(Int64, header[4][1:6])
        xlow = parse(Float64, header[5][1:18])
        ylow = parse(Float64, header[6][1:18])
        dx = parse(Float64, header[7][1:18])
        dy = parse(Float64, header[8][1:18])
        ## read variables
        body = txtorg[l+9:l+9+(mx+1)*my-1]

        if kw=="surface"
            vars = [parse(Float64, body[(i-1)*(mx+1)+j][26*(ncol-1)+1:26*ncol]) for i=1:my, j=1:mx]
            bath = [parse(Float64, body[(i-1)*(mx+1)+j][1:26]) for i=1:my, j=1:mx]
            vars[bath.<=0.0] .= NaN
            vars = vars.-eta0
            ## array
            amr[i] = AMR.patch(gridnumber,AMRlevel,mx,my,xlow,ylow,dx,dy,vars)
        elseif kw=="storm"
            ucol = ncol
            vcol = ncol+1
            pcol = ncol+2
            u = [parse(Float64, body[(i-1)*(mx+1)+j][26*(ucol-1)+1:26*ucol]) for i=1:my, j=1:mx]
            v = [parse(Float64, body[(i-1)*(mx+1)+j][26*(vcol-1)+1:26*vcol]) for i=1:my, j=1:mx]
            p = [parse(Float64, body[(i-1)*(mx+1)+j][26*(pcol-1)+1:26*pcol]) for i=1:my, j=1:mx]
            p = p./1e+2

            u[(abs.(u).<=1e-2) .& (abs.(v).<=1e-2)] .= NaN
            v[(abs.(u).<=1e-2) .& (abs.(v).<=1e-2)] .= NaN
            ## array
            amr[i] = AMR.stormgrid(gridnumber,AMRlevel,mx,my,xlow,ylow,dx,dy,u,v,p)
        end

        ## print
        #@printf("%d, ",gridnumber)

        ## counter; go to the next grid
		i += 1
        l = l+9+(mx+1)*my
    end
    ## return
    return amr
end
#################################
LoadForta(filename::String, ncol::Int) = LoadFortq(filename, ncol, kw="storm")
#################################

#################################
## Function: load time
#################################
function LoadFortt(filename::String)
    ## file open
    f = open(filename,"r")
    txtorg = readlines(f)
    close(f) #close
    ## parse timelaps from the 1st line
    timelaps = parse(Float64, txtorg[1][1:18])
    ## return
    return timelaps
end
#################################

#######################################
## Function: LoadFortq and LoadFortt
##      time-series of water surface
#######################################
function LoadSurface(loaddir::String; kw="surface"::String, eta0=0.0::Float64)

    ## define the filepath & filename
    if kw=="surface"
        fnamekw = "fort.q0"
        col=4
    elseif kw=="storm"
        fnamekw = "fort.a0"
        col=5
    end

    ## make a list
    if !isdir(loaddir); error("Directory $loaddir doesn't exist"); end
    flist = readdir(loaddir)
    idx = occursin.(fnamekw,flist)
    if sum(idx)==0; error("File named $fnamekw was not found"); end
    flist = flist[idx]

    ## the number of files
    nfile = length(flist)
    ## preallocate
    if kw=="surface"
        amr = Vector{AbstractVector{AMR.patch}}(undef,nfile)
    elseif kw=="storm"
        amr = Vector{AbstractVector{AMR.stormgrid}}(undef,nfile)
    end
    ## load all files
    tlap = vec(zeros(nfile,1))
    for it = 1:nfile
        if kw=="surface"
            amr[it] = AMR.LoadFortq(joinpath(loaddir,flist[it]), col, eta0=eta0)
        elseif kw=="storm"
            amr[it] = AMR.LoadForta(joinpath(loaddir,flist[it]), col)
        end
        tlap[it] = AMR.LoadFortt(joinpath(loaddir,replace(flist[it],r"\.." => ".t")))
    end

    #return (nfile, tlap, amr)
    ## AMR Array
    amrs = AMR.amr(nfile,tlap,amr)

    ## return value
    return amrs
end
#######################################
LoadStorm(loaddir::String) = LoadSurface(loaddir,kw="storm")
#######################################

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
    tmp = parse.(Float64, split(tmp, r"\s+"))
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
            topo[k,:] = parse.(Float64, split(line, r"\s+"))
        end
    end
    topo[topo.==nodata] .= NaN ## replace nodate to NaN
    topo = reverse(topo, dims=1) ## flip
    geo = AMR.geometry(ncols, nrows, xiter, yiter, topo)

    return geo
end
#################################
