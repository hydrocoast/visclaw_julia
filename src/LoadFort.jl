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
        amr = Array{Claw.patch}(undef,ngrid) ## preallocate
    elseif kw=="storm"
        amr = Array{Claw.stormgrid}(undef,ngrid)
    else
        error("kwarg kw is invalid")
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

        if kw=="surface"
            vars = [parse(Float64, body[(i-1)*(mx+1)+j][26*(ncol-1)+1:26*ncol]) for i=1:my, j=1:mx]
            bath = [parse(Float64, body[(i-1)*(mx+1)+j][1:26]) for i=1:my, j=1:mx]
            vars[bath.<=0.0] .= NaN
            vars = vars.-eta0
            ## array
            amr[i] = Claw.patch(gridnumber,AMRlevel,mx,my,xlow,ylow,dx,dy,vars)
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
	else
		error("Invalid input argument kw: $kw")
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
        amr = Vector{AbstractVector{Claw.patch}}(undef,nfile)
    elseif kw=="storm"
        amr = Vector{AbstractVector{Claw.stormgrid}}(undef,nfile)
    end
    ## load all files
    tlap = vec(zeros(nfile,1))
    for it = 1:nfile
        if kw=="surface"
            amr[it] = Claw.LoadFortq(joinpath(loaddir,flist[it]), col, eta0=eta0)
        elseif kw=="storm"
            amr[it] = Claw.LoadForta(joinpath(loaddir,flist[it]), col)
        end
        tlap[it] = Claw.LoadFortt(joinpath(loaddir,replace(flist[it],r"\.." => ".t")))
    end

    ## AMR Array
    amrs = Claw.AMR(nfile,tlap,amr)

    ## return value
    return amrs
end
#######################################
LoadStorm(loaddir::String) = LoadSurface(loaddir,kw="storm")
#######################################
