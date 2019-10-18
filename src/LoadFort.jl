### Functions to read ascii file and assign variables.
### Now available to read fort.qxxxx, fort.txxxx and fort.axxxx.
### Dataset is assigned into the type of stcuct.

#################################
## Function: fort.qxxxx reader
#################################
function LoadFortq(filename::String, ncol::Int; vartype="surface"::String, params::Claw.param=Claw.param())
    ## file open
    f = open(filename,"r")
    txtorg = readlines(f)
    close(f) #close

    ## count the number of lines and grids
    nlineall = length(txtorg)
    idx = occursin.("grid_number",txtorg)
    ngrid = length(txtorg[idx])

    if vartype=="surface"
        amr = Array{Claw.patch}(undef,ngrid) ## preallocate
    elseif vartype=="storm"
        amr = Array{Claw.stormgrid}(undef,ngrid)
    else
        error("kwarg vartype is invalid")
    end

    l = 1
    i = 1
    while l < nlineall
        ## read header
        #header = txtorg[1:8]
        header = txtorg[l:l+7]
        header = map(strip,header)
        gridnumber = parse(Int64, split(header[1],r"\s+")[1])
        AMRlevel = parse(Int64, split(header[2],r"\s+")[1])
        mx = parse(Int64, split(header[3],r"\s+")[1])
        my = parse(Int64, split(header[4],r"\s+")[1])
        xlow = parse(Float64, split(header[5],r"\s+")[1])
        ylow = parse(Float64, split(header[6],r"\s+")[1])
        dx = parse(Float64, split(header[7],r"\s+")[1])
        dy = parse(Float64, split(header[8],r"\s+")[1])
        ## read variables
        body = txtorg[l+9:l+9+(mx+1)*my-1]

        if vartype=="surface"
            vars = [parse(Float64, body[(i-1)*(mx+1)+j][26*(ncol-1)+1:26*ncol]) for i=1:my, j=1:mx]
            bath = [parse(Float64, body[(i-1)*(mx+1)+j][1:26]) for i=1:my, j=1:mx]
            vars[bath.<=0.0] .= NaN
            vars = vars.-params.eta0
            ## array
            amr[i] = Claw.patch(gridnumber,AMRlevel,mx,my,xlow,ylow,dx,dy,vars)
        elseif vartype=="storm"
            ucol = ncol
            vcol = ncol+1
            pcol = ncol+2
            u = [parse(Float64, body[(i-1)*(mx+1)+j][26*(ucol-1)+1:26*ucol]) for i=1:my, j=1:mx]
            v = [parse(Float64, body[(i-1)*(mx+1)+j][26*(vcol-1)+1:26*vcol]) for i=1:my, j=1:mx]
            p = [parse(Float64, body[(i-1)*(mx+1)+j][26*(pcol-1)+1:26*pcol]) for i=1:my, j=1:mx]
            p = p./1e+2

            # u[(abs.(u).<=1e-2) .& (abs.(v).<=1e-2)] .= NaN
            # v[(abs.(u).<=1e-2) .& (abs.(v).<=1e-2)] .= NaN

            ## array
            amr[i] = Claw.stormgrid(gridnumber,AMRlevel,mx,my,xlow,ylow,dx,dy,u,v,p)
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
LoadForta(filename::String, ncol::Int) = LoadFortq(filename, ncol, vartype="storm")
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
function LoadSurface(loaddir::String, filesequence::AbstractVector{Int64};
	                 vartype="surface"::String)

    ## define the filepath & filename
    if vartype=="surface"
        fnamekw = "fort.q0"
        col=4
    elseif vartype=="storm"
        fnamekw = "fort.a0"
        col=5
	else
		error("Invalid input argument vartype: $vartype")
    end

    ## make a list
    if !isdir(loaddir); error("Directory $loaddir doesn't exist"); end
    flist = readdir(loaddir)
    idx = occursin.(fnamekw,flist)
    if sum(idx)==0; error("File named $fnamekw was not found"); end
    flist = flist[idx]

	# load geoclaw.data
	params = Claw.GeoData(loaddir)

    ## the number of files
    nfile = length(flist)

	# file sequence to be loaded
    if filesequence==0:0; filesequence = 1:nfile; end
	if any(filesequence .< 1) || any(filesequence .> nfile)
		error("Incorrect file sequence was specified. (This must be from 1 to $nfile)")
	end

	## the number of files (to be loaded)
	nfile = length(filesequence)

    ## preallocate
    if vartype=="surface"
        amr = Vector{AbstractVector{Claw.patch}}(undef,nfile)
    elseif vartype=="storm"
        amr = Vector{AbstractVector{Claw.stormgrid}}(undef,nfile)
    end

    ## load all files
    tlap = vec(zeros(nfile,1))
	cnt = 0
    for it = filesequence
		cnt += 1
        if vartype=="surface"
            amr[cnt] = Claw.LoadFortq(joinpath(loaddir,flist[it]), col, params=params)
        elseif vartype=="storm"
            amr[cnt] = Claw.LoadForta(joinpath(loaddir,flist[it]), col)
        end
        tlap[cnt] = Claw.LoadFortt(joinpath(loaddir,replace(flist[it],r"\.." => ".t")))
    end

    ## AMR Array
    amrs = Claw.AMR(nfile,tlap,amr)

    ## return value
    return amrs
end
#######################################
LoadSurface(loaddir::String, filestart::Int64, filend::Int64) =
LoadSurface(loaddir, filestart:filend, vartype="surface")
#######################################
LoadSurface(loaddir::String, fileid::Int64) =
LoadSurface(loaddir, fileid:fileid, vartype="surface")
#######################################
LoadSurface(loaddir::String) =
LoadSurface(loaddir, 0:0, vartype="surface")
######################################
LoadStorm(loaddir::String, filesequence::AbstractVector{Int64}) =
LoadSurface(loaddir, filesequence, vartype="storm")
#######################################
LoadStorm(loaddir::String, filestart::Int64, filend::Int64) =
LoadSurface(loaddir, filestart:filend, vartype="storm")
#######################################
LoadStorm(loaddir::String, fileid::Int64) =
LoadSurface(loaddir, fileid:fileid, vartype="storm")
#######################################
LoadStorm(loaddir::String) =
LoadSurface(loaddir, 0:0, vartype="storm")
#######################################
