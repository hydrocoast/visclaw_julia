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
    amr = Array{AMR.patchdata}(undef,ngrid)

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
        amr[i] = AMR.patchdata(gridnumber,AMRlevel,mx,my,xlow,ylow,dx,dy,vars)

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
## Function: save figures as svg
#################################
function  AMRLoad(loaddir::String; col=4::Int)

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
    amr = Vector{AbstractVector{AMR.patchdata}}(undef,nfile)
    tlap = vec(zeros(nfile,1))
    for it = 1:nfile
        amr[it] = LoadFortq(joinpath(loaddir,flist[it]), ncol=col)
        tlap[it] = LoadFortt(replace(joinpath(loaddir,flist[it]), ".q" => ".t"))
    end
    #tlap=vec(tlap)

    ## AMR Array
    amrall = AMR.amrdata(nfile,tlap,amr)

    ## return value
    return amrall
end
#################################
