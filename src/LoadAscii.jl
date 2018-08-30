### Functions to read ascii file and assign variables.
### Now available to read fort.qxxxx, fort.txxxx and fort.axxxx.
### Dataset is assigned into the type of stcuct.

#################################
## Function: fort.qxxxx reader
#################################
function LoadFortq(filename::String; ncol=4::Int)
    ## file open
    f = open(filename,"r")
    txtorg = readlines(f)
    close(f) #close

    ## count the number of lines and grids
    nlineall = length(txtorg)
	#idx = contains.(txtorg,"grid_number")
    idx = occursin.("grid_number",txtorg)
	ngrid = length(txtorg[idx])
    #ngrid = sum()

    ## preallocate
    amr = Array{AMR.patch}(undef,ngrid)

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
        vars = [parse(Float64, body[(i-1)*(mx+1)+j][26*(ncol-1)+1:26*ncol]) for i=1:my, j=1:mx]

        ## array
        amr[i] = AMR.patch(gridnumber,AMRlevel,mx,my,xlow,ylow,dx,dy,vars)

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

#################################
## Function: save figures as svg
#################################
function Load(loaddir::String; col=4::Int)

    ## define the filepath & filename
    fnamekw = "fort.q"

    ## make a list
    if !isdir(loaddir); error("Directory $loaddir doesn't exist"); end
    flist = readdir(loaddir)
    idx = occursin.(fnamekw,flist)
    if sum(idx)==0; error("Not found"); end
    flist = flist[idx]

    ## the number of files
    nfile = length(flist)
    ## load all files
    amr = Vector{AbstractVector{AMR.patch}}(undef,nfile)
    tlap = vec(zeros(nfile,1))
    for it = 1:nfile
        amr[it] = AMR.LoadFortq(joinpath(loaddir,flist[it]), ncol=col)
        tlap[it] = AMR.LoadFortt(replace(joinpath(loaddir,flist[it]), ".q" => ".t"))
    end

    #return (nfile, tlap, amr)
    ## AMR Array
    amrqt = AMR.amr(nfile,tlap,amr)

    ## return value
    return amrqt
end
#################################

#################################
## Function: load topography
#################################
function LoadTopo(filename::String)
    if !isfile(filename); error("file $filename is not found."); end;
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
    ## grid spacing
    Δx = Δy = convert(Float64, convert(Float32, 1/cellsize))
    ## str into num
    topo = zeros(nrows, ncols)
    for k = 1:nrows
        line = replace(dataorg[k], r"^\s+" => "")
        topo[k,:] = parse.(Float64, split(line, r"\s+"))
    end
    topo[topo.==nodata] .= NaN
    ## flip
    topo = reverse(topo, dims=1)
    geo = AMR.geometry(ncols, nrows, xll, yll, topo)

    return geo
end
#################################
