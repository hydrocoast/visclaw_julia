###################################
"""
Function: read specification of a fixed grid
"""
function LoadFGmaxGrid(fname::String; FGid=0::Int64, nval=0::Int64)

    if !isfile(fname); error("File $fname is not found."); end
    # read all lines
    open(fname,"r") do f
        global txt = readlines(f)
    end

    # base parameters
    tstart_max = parse(Float64, split(strip(txt[1]), r"\s+")[1])
    tend_max = parse(Float64, split(strip(txt[2]), r"\s+")[1])
    dt_check = parse(Float64, split(strip(txt[3]), r"\s+")[1])
    min_level_check = parse(Int64, split(strip(txt[4]), r"\s+")[1])
    arrival_tol = parse(Float64, split(strip(txt[5]), r"\s+")[1])

    # point style
    point_style = parse(Int64, split(strip(txt[6]), r"\s+")[1])
    if point_style != 2
        error("point_style $point_style is not currently supported")
        return nothing
    else
        nx, ny = parse.(Int64, split(strip(txt[7]), r"\s+")[1:2])
        x1, y1 = parse.(Float64, split(strip(txt[8]), r"\s+")[1:2])
        x2, y2 = parse.(Float64, split(strip(txt[9]), r"\s+")[1:2])
    end

    #x = collect(Float64, LinRange(x1, x2, nx))
    #y = collect(Float64, LinRange(y1, y2, ny))
    fgmaxgrid = Claw.fgmaxgrid(FGid, fname, nval, nx, ny, (x1,x2), (y1,y2))

    # return
    return fgmaxgrid

end
###################################
"""
Function: read specification of a fixed grid
"""
LoadFGmaxGrid(fg::Claw.fgmaxgrid) = LoadFGmaxGrid(fg.file; FGid=fg.FGid, nval=fg.nval)
###################################

#################################
"""
Function: fort.FGx.valuemax and fort.FGx.aux1 reader
"""
function LoadFGmax(loaddir::String, FGid::Int64, nval::Int64, nx::Int64, ny::Int64; nval_save::Int64=nval)


    # fort.FGx.aux1
    filename = "fort.FG"*@sprintf("%d",FGid)*".aux1"
    auxfile = joinpath(loaddir,filename)
    ## check
    if !isfile(auxfile); error("Not found: $auxfile"); end

    # load
    dat = readdlm(auxfile)

    # assign
    npnt, ncol = size(dat)
    nlevel = ncol - 2
    #bath_level = dat[:,3:end]
    bath = permutedims(reshape(dat[:,3], (nx, ny)), [2 1])


    # fort.FGx.valuemax
    filename = "fort.FG"*@sprintf("%d",FGid)*".valuemax"
    loadfile = joinpath(loaddir,filename)
    ## check
    if !isfile(loadfile); error("Not found: $loadfile"); end

    # load
    dat = readdlm(loadfile)

    #=
    level = convert.(Int64, dat[:,3])
    bath = fill(NaN, (npnt,1))
    for i = 1:nlevel
      bath[level.==i] .= bath_level[level.==i, 1]
    end
    bath = permutedims(reshape(bath, (nx, ny)), [2 1])
    =#

    # assign
    if nval == 1
        h = permutedims(reshape(dat[:,4], (nx, ny)), [2 1])
        th = permutedims(reshape(dat[:,6], (nx, ny)), [2 1])
    elseif nval == 2
        h = permutedims(reshape(dat[:,4], (nx, ny)), [2 1])
        v = permutedims(reshape(dat[:,5], (nx, ny)), [2 1])
        th = permutedims(reshape(dat[:,6], (nx, ny)), [2 1])
        tv = permutedims(reshape(dat[:,7], (nx, ny)), [2 1])
    elseif nval == 5
        # maxixa
        h = permutedims(reshape(dat[:,4], (nx, ny)), [2 1])
        v = permutedims(reshape(dat[:,5], (nx, ny)), [2 1])
        M = permutedims(reshape(dat[:,6], (nx, ny)), [2 1])
        Mflux = permutedims(reshape(dat[:,7], (nx, ny)), [2 1])
        hmin = permutedims(reshape(dat[:,8], (nx, ny)), [2 1])
        # times when maxixa
        th = permutedims(reshape(dat[:,9], (nx, ny)), [2 1])
        tv = permutedims(reshape(dat[:,10], (nx, ny)), [2 1])
        tM = permutedims(reshape(dat[:,11], (nx, ny)), [2 1])
        tMflux = permutedims(reshape(dat[:,12], (nx, ny)), [2 1])
        thmin = permutedims(reshape(dat[:,13], (nx, ny)), [2 1])
    else
        error("nval $nval must be either 1, 2 or 5.")
    end

    if nval_save > nval; nval_save = nval; end

    if nval_save == 1
        fgmaxval = Claw.fgmaxval(bath,h,th)
    elseif nval_save == 2
        fgmaxval = Claw.fgmaxval(bath,h,v,th,tv)
    elseif nval_save == 5
        fgmaxval = Claw.fgmaxval(bath,h,v,M,Mflux,hmin,th,tv,tM,tMflux,thmin)
    else
        error("nval_save $nval_save must be either 1, 2 or 5.")
    end

    return fgmaxval

end
#################################
"""
Function: fort.FGx.valuemax reader
"""
LoadFGmax(loaddir::String, fg::Claw.fgmaxgrid; nval_save::Int64=fg.nval) =
LoadFGmax(loaddir, fg.FGid, fg.nval, fg.nx, fg.ny::Int64; nval_save=nval_save)
#################################
