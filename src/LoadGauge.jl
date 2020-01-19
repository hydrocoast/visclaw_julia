#################################
## Function: gauge*.txt reader
#################################
"""
Function: gauge*.txt reader
"""
function LoadGauge(dirname::String; eta0::Float64=0.0, labelhead::String="Gauge ", vel::Bool=false)
    if !isdir(dirname); error("$dirname is not found or directory"); end
    files = readdir(dirname)
    ind = map(x->occursin(r"gauge\d+\.txt",x),files)
    files = files[ind]
    if isempty(files); println("No gauge file"); return nothing end;
    nf = length(files)

    # preallocate
    gauges = Vector{VisClaw.gauge}(undef,nf)
    for k = 1:nf
        filename=joinpath(dirname,files[k])

        # read header
        f = open(filename,"r")
        header1 = readline(f)
        close(f)
        id = parse(Int64,header1[13:17])
        loc = [parse(Float64,header1[30:46]), parse(Float64,header1[48:64])]

        # read time-series of vars in the certain colmns
        dataorg = readdlm(filename, skipstart=2)
        AMRlevel = convert.(Int64,dataorg[:,1])
        time = convert.(Float64,dataorg[:,2])
        nt = length(time)
        eta = convert.(Float64,dataorg[:,6])
        if vel
            u = convert.(Float64,dataorg[:,4])
            v = convert.(Float64,dataorg[:,5])
        end
        eta = eta.-eta0

        # label
        label = labelhead*@sprintf("%d",id)

        # instance
        if vel
            gauges[k] = VisClaw.gauge(label,id,nt,loc,AMRlevel,time,eta,u,v)
        else
            gauges[k] = VisClaw.gauge(label,id,nt,loc,AMRlevel,time,eta)
        end
    end

    return gauges
end
#################################
